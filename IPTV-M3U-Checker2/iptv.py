#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @Time    : 2024/04/16 17:20
# @Author  : Allen zh
# @Email   : allenzh@outlook.com
# @File    : iptv.py

import shutil
import time
import os
import sys
import json
from urllib.parse import urlparse
import requests
import threading
from queue import Queue,Empty
import pandas as pd
import utils.tools
import utils.db
import utils.downloader
from zyrobot import DingtalkChatbot

class Iptv(object):
    playlist_file = 'playlists/'
    output_file = 'output/'
    delay_threshold = 6000  # 响应延迟阈值，单位毫秒。超过这个阈值则认为直播源质量较差
    MaxSourceCount=2000     #检测最长节目数量
    __dbdata=[]
    __playlist=[]
    __logger=print
    ipv6addr=''     #本机ipv6地址
    
    def __init__(self, bReNew=False,logger=None):
        '''类实例初始化
            @bReNew: 是否删除旧库，新建数据库
            @logger=None,logger类，默认为print函数
        '''
        if(logger):self.__logger=logger
        self.T = utils.tools.Tools()
        self.DB = utils.db.DataBase(bReNew=bReNew,logger=logger)   #renew a database
        self.set_tvorders(bReNew=True)
        try:
            ret=requests.get(url='https://6.ipw.cn')#https://v6.ident.me')
            if(ret.status_code==200):self.ipv6addr=ret.text
        except:
            pass

    def set_tvorders(self,xlsfilename=r'playlists/sortlist.xlsx',bReNew=True):
        '''
        设置节目排序先后
        @xlsfilename:需要排序的excel文件
        @bReNew:是否清空旧数据
        '''
        return self.DB.set_tvorders(xlsfilename,bReNew)

    def split_urls(self,urlstr):
        urls=urlstr.split('#')
        url_list=[]
        for url in urls:
            if (url.lower().startswith('http://')== True or url.lower().startswith('https://')== True):
                url_list.append(url)
        return url_list                        

    def unique_list(self,list_obj, primary_key,dbOpMode=1):
        '''#节目列表去重，同时去除数据库排序列表中排序9999（不检查）的节目列表
            list_obj:待合并的列表
            primary_key:列表字典关键字
            dbOpMode:=0,只更新不插入; =1,有记录就update或者无记录就插入
        '''
        list_obj_dict = {i.get(primary_key): i for i in list_obj}
        list_obj = list(list_obj_dict.values())
        sql="select title from tvorders where tvorder>=9999"
        rows = self.DB.query(sql)
        for row in rows:
            for obj in list_obj:
                if(row[0] == obj['title']):
                    list_obj.remove(obj)
                    break
        
        if(dbOpMode==0):
            sql="select title from playlists "
            rows = self.DB.query(sql)
            for obj in list_obj:
                bFound=False
                for row in rows:
                    if(row[0] == obj['title']):
                        bFound=True
                        break
                if(not bFound):
                    list_obj.remove(obj)

        '''
        sql='select uniquename,title from tvorders where tvorder<9999'
        df = self.DB.querypd(sql)
        df.set_index('title',inplace=True)
        dflist=pd.DataFrame(list_obj)
        dflist.set_index('title',inplace=True)
        dflist['uniquename']=dflist['title'].map(df)
        '''
            
        return list_obj    
    
    #下载文件到本地
    def getFiles(self,urls):
        checkfile_list=[]
        if(sys.platform == 'win32'):
            temppath=os.getenv('TEMP')
        else:   # =='linux'
            temppath='/tmp'
        for url in urls:
            if(url[:4].lower()=='http'):
                names=url.split('/')
                name = names[-1].split('?')[0]
                if (len(name)==0 and len(names)<=3): name='default.txt'
                path = "%s/%s" % (temppath,name)
                try:
                    r = requests.get(url)
                    if(r.status_code==200):
                        r.encoding = 'utf-8'
                        with open(path, "wb") as fp:
                            fp.write(r.content)
                        self.__logger("url-get:"+url)
                        checkfile_list.append(path)
                    else:
                        self.__logger("Warning Get url "+url)
                except:
                        self.__logger("Warning Get url "+url)
            elif(url[:6].lower()=='ftp://'):
                pass
            else:  #本地文件
                checkfile_list.append(url) 
        return checkfile_list    

    
    def getPlaylist(self,ctype=0x01,checkfile_list=[],keywords=[]):        
        '''从文件/url/DB获取节目列表
        @ctype:(可与或)
        --0x01:本地文件。--0x02:外部文件(url或其他路径)。--0x04:本地数据库。--0x08:仅测试。--0x10:仅匹配数据库tvorders已有节目表，另外加上keywords包含的*节目名称*
        @checkfile_list,要获取的节目文件列表，如果为空的话，默认从文件夹取所有txt/m3u文件
        @keywords:匹配关键字列表，按照*keyword*模式匹配title.
        @返回playlist
        '''
        playList = []
        #urlList=[]
        files=[]
        # 读取文件
        if(ctype & 0x01 >0 ):   #本地文件
            files = os.listdir(self.playlist_file)
            for i in range(len(files)):
                files[i]=self.playlist_file+files[i]
        if(ctype & 0x02 >0 ):   #外部文件
            files.extend(self.getFiles(checkfile_list))

        if(ctype & 0x08 >0 ):   #仅测试
            files= self.getFiles(checkfile_list)

        for p in files:
            if os.path.isfile(p):
                if(p.lower() .endswith('.m3u')==True):
                    filetype='m'
                elif(p.lower() .endswith('.txt')==True):
                    filetype='t'
                else:
                    continue
                with open(p, 'r', encoding='utf-8') as f:
                    self.__logger("file:"+p+",ext="+filetype)
                    lines = f.readlines()
                    if(1>2):#filetype=='t'):
                        total = len(lines)
                        for i in range(0, total):
                            line = lines[i].strip('\n')
                            item = line.split(',', 1)
                            if len(item) == 2:
                                data = {
                                    'title': item[0],
                                    'url': item[1],
                                    'uniquename':item[0],
                                    'delay':99999,
                                }
                                playList.append(data)
                                #urlList.append(data['url'])
                    else:
                        title=None
                        url=None
                        tvgroup='Default'
                        for line in lines:
                            line = line.strip('\n')
                            item = line.split(',', 1)
                            
                            if (item[0][:8] == '#EXTINF:'):
                                title = item[1]
                            elif (item[0][:4].lower() == 'http'):
                                url = item[0]
                            elif (len(item)==2):
                                if(item[1][:4].lower()== 'http'):
                                    title=item[0]
                                    url  =item[1]
                                elif(item[1][:7]=='#genre#'):
                                    tvgroup=item[0]
                                    title=None
                                else:
                                    continue
                            else:
                                continue
                            if(title != None and url != None):
                                url_list =self.split_urls(url)  #情况1.允许url=url1#url2...格式
                                for urlitem in url_list:
                                    data = {
                                        'title': title,
                                        'url': urlitem,
                                        'tvgroup':tvgroup,
                                        'uniquename':title,
                                        'delay':99999,
                                    }
                                    playList.append(data)
                                    #urlList.append(data['url'])
                                #title=None     #情况2.允许url分割在多行
                                url=None
        #playList=playList[:self.MaxSourceCount]
        #urlList=urlList[:self.MaxSourceCount]
        
        if(len(playList)>0):
            #去除url重复的行
            df=pd.DataFrame(playList)
            df.drop_duplicates(subset=['url'],inplace=True)
            #如果不支持ipv6则去除
            if(self.ipv6addr==''):
                df=df.query("url.str.contains('://\\[', regex=True) == False", engine='python')

            df2=pd.DataFrame()
            if(ctype & 0x10 >0):    #允许关键字清单的节目加入(适用与只匹配在预设清单(tvorders)里面的节目)
                for keyword in keywords:
                    strfilter= f"title.str.contains('{keyword}', regex=True) == True"
                    df2=pd.concat([df.query(strfilter,engine='python'),df2],ignore_index=True)

            #去除tvorders不检查的行
            dftvorders=self.DB.querypd('select title,uniquename,tvgroup,tvorder from tvorders where tvorder<9999')
            dflist=pd.merge(df,dftvorders,how='inner',on='title')
            dflist.rename(columns={'uniquename_y':'uniquename','tvgroup_y':'tvgroup'},inplace=True)

            #再加上关键字清单内的节目
            if(len(df2)>0):
                dflist=pd.concat([dflist,df2])

            #去除>MaxSourceCount的多余行 
            dflist=dflist[:self.MaxSourceCount]

            '''
            if(ctype & 0x08 >0 ):   #仅测试
                tmp_table='tmp_'+self.DB.table
                df.to_sql(name=tmp_table,con=self.DB.conn,index=False,if_exists='replace')
            else:
                tmp_table=self.DB.table
                df.to_sql(name=tmp_table,con=self.DB.conn,index=False,if_exists='append')

            #去除tvorders不检查的行
            sql=f'delete from {tmp_table} where title in (select title from tvorders where tvorder=9999)'
            self.DB.execute(sql)

            #去除>MaxSourceCount的多余行 
            sql=f'delete  from {tmp_table} where id in (select id from {tmp_table} where delay=99999 Limit {self.MaxSourceCount},90000) and delay=99999'
            self.DB.execute(sql)

            dflist=self.DB.querypd(f'select * from {tmp_table} where delay=99999')
            df=self.DB.querypd(f'select title,uniquename,tvorder from tvorders where tvorder<9999 ')
            dflist=pd.merge(dflist,df,how='left',on='title')
            dflist.rename(columns={'uniquename_y':'uniquename'},inplace=True)
            '''
            dflist.drop(columns=['uniquename_x','tvgroup_x'],inplace=True)
        else:
            dflist=pd.DataFrame()
        
        if(ctype & 0x04 >0 ):   #从数据库获取列表
            df= self.DB.querypd(f'select * from {self.DB.table} where delay<99999 ')
            if(len(dflist)>0):
                dflist=pd.concat([dflist,df])
                dflist.drop_duplicates(subset=['url'],inplace=True)
                dflist=dflist[:self.MaxSourceCount]
            else:
                dflist=df

        if(len(dflist)>0):
            dflist['uniquename'].fillna(dflist['title'],inplace=True)   #如果没有标准名称，则设为title
            playList=json.loads(dflist.to_json(orient='records'))
        
        return playList

    #从数据库获取节目列表
    def getPlaylistFromDb(self,sql=''):
        playList =[]
        if (sql==''):sql=f'select * from {self.DB.table}'
        df = self.DB.querypd(sql)
        if(len(df)>0):
            playList=df.to_json(orient='records')
        
            #urlList.append(data['url'])
            #playList= self.unique_list(playList,'url')
        return json.loads(playList)

    #检测播放节目列表
    def checkPlayList(self, playlistQueue:Queue,threadNo=None,SpeedTest=1):
        '''
        :return: True or False
        验证每一个直播源，记录所有的delay值，超过delay_threshold的记为delay_threshold。
        SpeedTest:=0不测速，>0测速，=720表示限制视频分辨率720p以下
        '''
        #total = len(playList)
        #if (total <= 0): return False
        if(threadNo == None):threadNo=threading.current_thread().ident
        #for i in range(0, total):
        while not playlistQueue.empty():
            try:
                playList=playlistQueue.get(block=False)
                tmp_uniquename = playList['uniquename']
                tmp_title = playList['title']
                tmp_url = playList['url']
                tvgroup = playList['tvgroup']
                tvorder = playList['tvorder']
                #self.__logger('Thread %d Checking[ %s / %s ]:%s,%s..' % (threadNo,i+1, total, tmp_title,tmp_url[:99]),end='.')
                self.__logger('Thread %d Checking, leave[ %s ]:%s,%s..' % (threadNo, playlistQueue.qsize(), tmp_title,tmp_url[:99]),end='.')
                netstat = self.T.chkPlayable(tmp_url)
                if 0 < netstat < self.delay_threshold:
                    if SpeedTest>0 :
                        (speed,width,height,cformat) = utils.downloader.start(tmp_url,True,1)
                        speed = speed /1024/1024
                    else:
                        (speed,width,height,cformat) =(0,0,0,"NaN")
                    data = {
                        'title': tmp_title,
                        'uniquename':tmp_uniquename,
                        'url': tmp_url,
                        'delay': (netstat if (SpeedTest<100 or SpeedTest>height) else netstat+self.delay_threshold),
                        'speed': "%s Mb/s" % "{:.2f}".format(speed) if speed > 0 else "NaN",
                        'videosize': "%d*%d"% (width,height),
                        'format':cformat,
                        'tvgroup':tvgroup,
                        'tvorder':tvorder,
                    }
                    self.addData(data)

                else:
                    data = {
                        'title': tmp_title,
                        'uniquename':tmp_uniquename,
                        'url': tmp_url,
                        'delay': self.delay_threshold,
                        'speed': "NaN",
                        'videosize': "",
                        'format':"NaN",
                        'tvgroup':tvgroup,
                        'tvorder':tvorder,
                    }
                    self.addData(data)
                    
                self.__logger("(%s)%ds" % (data['videosize'],data['delay']),end='\n')
            except Empty:
                break

        self.__logger("[%s] thread %d(%d) Exited"%(time.asctime(),threadNo,threading.current_thread().ident))

    def addData(self, data):
        self.__dbdata.append(data)
    
    def saveData(self):
        '''将数据更新/插入到数据库
        '''
        self.DB.execute('delete from %s'%(self.DB.table))
        self.DB.insert(self.__dbdata)
            
    #@property
    def output(self,ctype=0x01):
        '''#输出检测结果
            oytpe:文件格式,包括：
                       0x01(001b):diyp播放器（缺省）
                       0x02(010b):m3u标准格式
                       0x04(100b):txt标准格式
                       0x08:测试模式。
                       可以是以上混合
        '''
        #sql = "SELECT * FROM %s WHERE delay='%d' " % (self.DB.table,self.delay_threshold)
        #result = self.DB.query(sql)
        i=0
        for row in self.__dbdata:
            if(row['delay']>=self.delay_threshold):
                i=i+1
        self.__logger('共检测得 %s/%s 个无效直播源！' % (i,len(self.__dbdata)) )
        
        df=pd.DataFrame(self.__dbdata)
        #sql = "SELECT p.* from %s p left join tvorders o on p.title=o.title and o.tvorder<9999 order by p.tvgroup,o.tvorder,p.title " % (self.DB.table)
        #df = self.DB.querypd(sql)

        def color_cell(cell):
            if cell == self.delay_threshold:
                return 'background-color: #DC143C'
            elif cell > 3000:
                return 'background-color: #FF1493'
            elif cell > 1000:
                return 'background-color: #FFFF00'
            elif cell > 500:
                return 'background-color: #90EE90'
            else:
                return 'background-color: #008000'

        if(len(df)>0):
            df.sort_values(by=["tvgroup","tvorder"],ascending=True,inplace=True)
            df=df.query(f'delay<{self.delay_threshold}').reset_index(drop=True)
        
        fnamelist=[]
        if(len(df)>0):
            self.T.mkdir(self.output_file)
            self.T.del_file(self.output_file)
            title = time.strftime("%Y%m%d_%H%M%S", time.localtime())  #+ '_' + secrets.token_urlsafe(16)

            if(ctype & 0x01 >0):   #'diyp'        
                fname="./%s/diyp%s.txt" % (self.output_file, title)
                with open(fname, 'w', encoding='utf-8') as file:
                    tvgroup=''
                    prev_uniquename=''
                    for i in df.index:                
                        if(tvgroup != df['tvgroup'][i]):
                            file.write('\n'+ df['tvgroup'][i] + ',#genre#\n')
                            tvgroup=df['tvgroup'][i]
                            seps=''
                        else:
                            seps='\n'
                        if(i>0 and prev_uniquename==df['uniquename'][i]): 
                            file.write('#'+df['url'][i])
                        else:
                            prev_uniquename=df['uniquename'][i]
                            file.write(seps+prev_uniquename+','+df['url'][i])
                    file.write('\n')
                    fnamelist.append(fname)

            if(ctype & 0x02 >0 ):   #'txt'        
                fname="./%s/%s.txt" % (self.output_file, title)
                with open(fname, 'w', encoding='utf-8') as file:
                    tvgroup=''
                    for i in df.index:                
                        if(tvgroup != df['tvgroup'][i]):
                            file.write('\n'+ df['tvgroup'][i] + ',#genre#\n')
                            tvgroup=df['tvgroup'][i]
                            seps=''
                        else:
                            seps='\n'
                        prev_uniquename=df['uniquename'][i]
                        file.write(seps+prev_uniquename+','+df['url'][i])
                    file.write('\n')
                    fnamelist.append(fname)

            if(ctype & 0x04 >0):   #'m3u'        
                fname="./%s/%s.m3u" % (self.output_file, title)
                with open(fname, 'w', encoding='utf-8') as file:
                    tvgroup=''
                    prev_uniquename=''
                    tvlogo=''
                    file.write('#EXTM3U\n')
                    for i in df.index:
                        tvgroup=df['tvgroup'][i]                
                        prev_uniquename=df['uniquename'][i]                        
                        line=f'#EXTINF:-1 tvg-name="{prev_uniquename}" {tvlogo} group-title="{tvgroup}",{prev_uniquename}\n'
                        file.write(line +df['url'][i] + '\n')
                    fnamelist.append(fname)

            out = (
                    df.style
                    .set_properties(**{'text-align': 'center'})
                    .applymap(color_cell, subset=['delay'])
                    .to_excel("./%s/%s.xlsx" % (self.output_file, title), index=False)
            )
            #df.to_csv("./%s/%s.txt" % (self.output_file, title),header=None,index=None,sep=',')
        return fnamelist

    def sendit(self,fnames, destUris,sendtype=0):
        ''' #output后续处理
            @fnames:对应文件路径列表
            @destUrls:目的地文件路径列表
            @sendtype:0，默认copy
        '''
        if (sendtype==0):   #copy
            for i in range(len(fnames)):
                try:
                    if(destUris[i]!=''):
                        shutil.copy(fnames[i], destUris[i])
                        self.__logger("file copy to "+destUris[i])
                except Exception as e:
                    self.__logger (e)
                    self.__logger("Error occurred while copying file.")
        elif (sendtype==1):
            pass
            #self.__logger('直播源检测结束！', 'https://view.officeapps.live.com/op/view.aspx?src=%s/IPTV-M3U-Checker-Bot/%s/%s.xlsx' % (your_domain, self.output_file, title))
        else:
            pass


    def runcheck(self,playList,bSavedb=True, bTestSpeed=True, threadCount=5):
        ''' #多线程跑检测
            @playList:需要跑的节目列表
            @bSavedb:是否更新到数据库，default=True
            @threadCount:开启线程数量，default=5
        '''
        self.__logger('直播源检测开始！')
        if(len(playList)==0):
            return 0
        i=0
        playlistQueue=Queue()
        for mytv in playList:
            playlistQueue.put(mytv)
            i=i+1
            if(i>=self.MaxSourceCount):
                break
        try:
            thrlist=[]
            for i in range(threadCount):
                thread= threading.Thread(target=self.checkPlayList,args=(playlistQueue,i+1,bTestSpeed,))
                thrlist.append(thread)
            #self.__logger('Total thread Num=%d*%d/%d'%(len(thrlist),nUrlsPerThread,sourceLen))
            
            for thr in thrlist:
                thr.start()

            #等待检测队列为是否为空，然后最多等待10*5秒后强制退出主进程
            while not playlistQueue.empty():
                time.sleep(5)
            idlist=[]
            for i in range(10):
                for thr in thrlist:
                    if (thr.is_alive()): idlist.append(thr.ident)
                if(len(idlist)>0):
                    self.__logger("[%s] Continue waiting threadids:%s"%(time.asctime(),idlist))         
                    time.sleep(5)
                    idlist=[]
                else:
                    break
            if(len(idlist)>0):
                self.__logger("timeout threadid:%s ,abandoned."%(idlist))
            
            '''
            for i in range(len(thrlist)):
                thrlist[i].join()
                self.__logger("[%s] waiting threadid:%d exited"%(time.asctime(),thrlist[i].ident))
            '''

            self.__logger("[%s] Now start save data..."%(time.asctime()))
            if(bSavedb):
                self.saveData()
        
        except Exception as e:
            import traceback
            self.__logger( traceback.format_exc() )
            self.__logger ("error found at thread")
            return -1

        self.__logger('直播源检测结束！')
        return len(self.__dbdata)
    

if __name__ == '__main__':
    #db=utils.db.DataBase()
    #db.query("select * from playlists")
    #sys.exit()
    # WebHook地址
    webhook = 'https://oapi.dingtalk.com/robot/send?access_token=这里填写自己钉钉群自定义机器人的token'
    secret = 'SEC11b9...这里填写自己的加密设置密钥'  # 创建机器人勾选“加签”选项时使用
    xiaoding = DingtalkChatbot(webhook, secret=secret)
    checkfile_list=[]#'https://gitee.com/pczx816571/gitee/raw/master/xxtv.txt']
    
    print('开始......')
    time1=time.time()
    bReNew=False
    iptv = Iptv(bReNew=bReNew,logger=None)
    iptv.MaxSourceCount=20

    ctype=0x08#0x02|0x04
    myList=iptv.getPlaylist(ctype=ctype,checkfile_list=checkfile_list)
    iptv.runcheck(myList,bSavedb=(ctype&0x08>0))
    fnames=iptv.output(0x01|0x04)
    iptv.sendit(fnames,['/pczx816571/gitee/raw/master/xxtv.txt','hahah/test2.m3u'])
    print('结束.....%s秒'%str(time.time()-time1))
   