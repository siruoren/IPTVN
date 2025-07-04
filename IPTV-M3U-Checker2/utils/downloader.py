#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @Time    : 2024/04/17 00:50
# @Author  : Allen zh
# @Email   : allenzh@outlook.com
# @File    : downloader.py

import time
from urllib.request import urlopen
try:
    import cv2
    _g_CV2=True
except ImportError:
    _g_CV2=False

class Downloader:
    def __init__(self, url,m3url=None):
        self.url = url
        self.startTime = time.time()
        self.receive = 0
        self.endTime = None
        self.m3url=m3url

    def getSpeed(self):
        if self.endTime and self.receive != -1:
            return self.receive / (self.endTime - self.startTime)
        else:
            return -1

    def downloadTester(self,retry):
        chunck_size = 10240
        for i in range(retry):
            try:
                resp = urlopen(self.url, timeout=2)
                # max 5s
                while time.time() - self.startTime < 5:
                    chunk = resp.read(chunck_size)
                    if not chunk:
                        break
                    self.receive = self.receive + len(chunk)
                resp.close()
                break
            except BaseException as e:
                print("downloadTester got an error %s,retry %d, %s\n" % (e,i+1,self.m3url))
                self.receive = -1
                #retry it
                self.startTime=time.time()
                
        self.endTime = time.time()

    def getVideoFormat(self):
        video_url=self.url
        width=0
        height=0
        cformat="NaN"

        if(len(video_url)>0):
            try:
                video = cv2.VideoCapture(video_url)
                if(video.isOpened()):
                    width = video.get(cv2.CAP_PROP_FRAME_WIDTH)
                    height = video.get(cv2.CAP_PROP_FRAME_HEIGHT)
                    frcc=int(video.get(cv2.CAP_PROP_FOURCC))
                    c1=chr(frcc & 0xFF)
                    c2=chr((frcc & 0xFF00)>>8)
                    c3=chr((frcc & 0xFF0000)>>16)
                    c4=chr((frcc & 0xFF000000)>>24)
                    if(0x20<=c1 and c1<=0x7a and 0x20<=c2 and c2<=0x7a and 0x20<=c3 and c3<=0x7a and 0x20<=c4 and c4<=0x7a ): 
                        cformat = "%c%c%c%c"%(c1,c2,c3,c4)
                    else:
                        cformat= "%x"%(frcc)
                    video.release()
            except:
                pass
        return (width,height,cformat)

def getStreamUrl(m3u8):
    urls = []
    if(m3u8.lower().endswith('.m3u8') == False):
        urls.append(m3u8)
        return urls
    try:
        prefix = m3u8[0:m3u8.rindex('/') + 1]
        with urlopen(m3u8, timeout=2) as resp:
            top = False
            second = False
            firstLine = False
            for line in resp:
                line = line.decode('utf-8')
                line = line.strip()
                # 不是M3U文件，默认当做资源流
                if firstLine and not '#EXTM3U' == line:
                    urls.append(m3u8)
                    firstLine = False
                    break
                if top:
                    # 递归
                    if not line.lower().startswith('http'):
                        line = prefix + line
                    urls += getStreamUrl(line)
                    top = False
                if second:
                    # 资源流
                    if not line.lower().startswith('http'):
                        line = prefix + line
                    urls.append(line)
                    second = False
                if line.startswith('#EXT-X-STREAM-INF:'):
                    top = True
                if line.startswith('#EXTINF:'):
                    second = True
            resp.close()
    except BaseException as e:
        print('get stream url failed! %s' % e)
    finally:
        return urls


def start(url,bChkFormat=False,retry=1):
    stream_urls = []
    if url.lower().endswith('.flv'):
        stream_urls.append(url)
    else:
        stream_urls = getStreamUrl(url)
    # 速度默认-1
    speed = -1
    width = 0
    height= 0 
    cformat="NaN"
    if len(stream_urls) > 0:
        stream = stream_urls[0]
        downloader = Downloader(stream,url)
        if(bChkFormat):
            (width,height,cformat)=downloader.getVideoFormat()
        downloader.downloadTester(retry)
        speed = downloader.getSpeed()
    return (speed,width,height,cformat)
