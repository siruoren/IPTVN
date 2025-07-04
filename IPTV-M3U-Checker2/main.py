#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @Time    : 2024/04/16 17:20
# @Author  : Allen zh
# @Email   : allenzh77@gmail.com
# @File    : main.py

import time
import sys
import json
from iptv import Iptv
from zyrobot import DingtalkChatbot

# 在线预览文件域名 http / https
your_domain = False#'https://list.domain.com'

def load_config():
    '''获取运行配置信息'''
    try:
        with open(r"myconfig.json",encoding='utf-8') as json_file:
            parms = json.load(json_file)
            if ('ctype' not in parms):parms['ctype']=0x01
            if ('checkfile_list' not in parms):parms['checkfile_list']=[]
            if ('keywords'  not in parms):parms['keywords']=[]
            if ('otype' not in parms):parms['otype']=0x01|0x02|0x10
            if ('sendfile_list' not in parms):parms['sendfile_list']=[]
            if ('newDb'  not in parms):parms['newDb']=False
            if ('webhook'  not in parms):parms['webhook']=''
            if ('secret'  not in parms):parms['secret']=''
            if ('max_check_count' not in parms):parms['max_check_count']=2000
            
    except:
        print("未发现myconfig.json配置文件，或配置文件格式有误。")
        return {}
    return parms

if __name__ == '__main__':
    '''
    if (len(sys.argv) >= 1 ):
        for parm in sys.argv[1:]:
            checkfile_list.append (parm)
    '''
    
    parms=load_config()
    xiaoding = DingtalkChatbot(parms['webhook'], secret=parms['secret'])
    print('开始......')
    time1=time.time()
    iptv = Iptv(bReNew=parms['newDb'],logger=None)
        
    #设置最大解析节目源数量(可选,默认2000)
    iptv.MaxSourceCount=parms['max_check_count']

    myList=iptv.getPlaylist(ctype=parms['ctype'],checkfile_list=parms['checkfile_list'],keywords=parms['keywords'])

    iptv.runcheck(myList,bSavedb=(parms['ctype']&0x08==0),bTestSpeed=parms['testspeed'])
    fnames=iptv.output(parms['otype'])   #diyp 0x01|m3u 0x02|标准txt 0x04 |测试 0x08
    iptv.sendit(fnames,parms['sendfile_list'])
    print('结束.....%s秒'%str(time.time()-time1))
   
    
    