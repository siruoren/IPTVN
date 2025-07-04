# IPTV-M3U-Checker2 直播源批量检测程序

## 简介

针对目前`个人使用`的痛点，实现多个直播源`自动化定时检测`，便于及时替换失效源。一般不会出现大规模失效，除非同一域名/ip挂了，那么替换即可。

本项目改自<a href="https://github.com/AlexKwan1981/iptv-m3u8-checker" target="_blank">AlexKwan1981/iptv-m3u8-checker</a>，感谢！

增加了<a href="https://ding-doc.dingtalk.com/doc#/serverapi2/krgddi" target="_blank">钉钉群机器人</a>（可选），可以配合定时任务，实现直播源的定时检测与通知，使用`Office Web Viewer`展示测试结果。

增加了直播源连接速度、视频文件格式解析测试（占用资源和时间可能较长，参数testspeed>0），注意部分linux机器没有显卡无法安装cv2模块，所以视频文件格式解析可能无法检测出结果。参考项目<a href="https://github.com/chaichunyang/m3u-tester" target="_blank">chaichunyang/m3u-tester</a>，感谢！

目前支持`.txt`和'.m3u'直播源的检测。

增加了多线程检测（默认开5个线程）。

检测结果可以给各种播放器支持的格式(包括标准txt格式，m3u格式，以及diyp支持的txt格式）。
1. txt格式主要是（节目名,url），一行一条；
2. m3u格式带（分组、名称、url）（不含logo地址）；
2. diyp支持的txt格式主要跟标准txt格式区别是，同一个节目如果有多个url地址的话，一行内用#隔开。


同时支持按照playlists/sortlist.xlsx文件进行排序和筛选，字段包括：
```
  - 节目名称（title），比如CCTV-1, CCTV-1 综合，CCTV1，CCTV-1 4K等等
  - 节目统一名称（uniquename），比如CCTV-1。
  - 分组名称（tvgroup），比如1.央视，前面带数字1主要是排序方便。
  - 排序（tvorder），同一分组内的排序次序。显示时按照tvgroup，tvorder进行排序。注意uniquename和tvorder最好一致，不然一个节目可能分拆成多条记录显示。

支持将检测结果文件输出到指定目的地，目前只支持copy到目的路径，未来可支持http/ssh等方式copy。
```

## 主要功能
对直播源进行批量检测，并（可选）通过钉钉群机器人及时反馈检测结果，同时输出给各种播放器支持的格式。  

- 1.检查本地文件夹(playlists)内所有文件
    - ctype=0x01; myList=iptv.getPlaylist()
- 2.检查外部指定文件
    - ctype=0x02; myList=iptv.getPlaylist(ctype=ctype,checkfile_list=checkfile_list)
- 2.2.检查外部指定文件；除了在预设清单(tvorders)里面的节目外, 允许关键字清单的节目加入
    - ctype=0x10|0x02; myList=iptv.getPlaylist(ctype=ctype,checkfile_list=checkfile_list,keywords=keywords)
- 3.检查本地文件夹，加上外部指定文件
    - ctype=0x01|0x02; myList=iptv.getPlaylist(ctype=ctype,checkfile_list=checkfile_list)
- 3.2.【默认】检查本地文件夹，加上外部指定文件；除了在预设清单(tvorders)里面的节目外, 允许关键字清单的节目加入
    - ctype=0x01|0x02|0x10; myList=iptv.getPlaylist(ctype=ctype,checkfile_list=checkfile_list,keywords=keywords)
 
- 将待检测的直播源文件放置到`playlists/`文件夹下：  
  - 支持在线直链（如`raw.githubusercontent.com`，`gitee.com/*/raw/`等，可添加多个），自动下载至`playlists/`文件夹，文件名相同则直接覆盖（类似自动更新）
  - 支持多个本地文件
  - 目前仅支持`.txt`格式、'.m3u'格式
- 直播源检测
  - 对每个连接进行测试，同时记录当前网络对该连接的延迟（参考<a href="https://github.com/EvilCult/iptv-m3u-maker" target="_blank">EvilCult/iptv-m3u-maker</a>）  
  - 支持测试有效直播源的连接速度
  - 将失效的直播源以文本形式通过钉钉群机器人通知
  <img src="https://ae01.alicdn.com/kf/Ud43b3682d4494d45a0248eace0178187E.jpg" height = "300" alt="钉钉群通知展示" align=center />
  
  - 通过`DataFrame.to_excel()`在`output/`目录下生成全部测试结果的Excel 预览，以链接形式通过钉钉群机器人发送
  <img src="https://ae01.alicdn.com/kf/U080f091db1d24cc788b72b65efef7b64H.jpg" height = "400" alt="钉钉群通知展示" align=center />
  
  - 生成的文件名以`测试时间`命名，防止直播源泄露

## 使用方法

本项目基于 **python3** 进行开发 

- 模块安装 Requirements
```
pip3 install pandas
pip3 install requests
pip3 install DingtalkChatbot
pip3 install openpyxl
pip3 install cv2, opencv-python

* 国内可以使用-i参数加快下载速度
如：pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

- 主要参数  (myconfig.json)
- -`testspeed`：是否开启直播源连接速度测试，默认关闭（开启可能增加耗时与资源占用）
    - 0:关闭
    - 1:开启
    - \>100:开启并且筛选分辨率低于该数字的作为无效来源
- -`ctype`:检查类型（可以组合）
    - 1（0x01）：检查本地playlists文件夹下的.txt,.m3u文件
    - 2（0x02）：检查外部文件，对应checkfile_list参数
    - 4（0x04）：检查上次检查的节目源（保存在sqlite3数据库中）
    - 8（0x08）：只检测，不保存/更新结果
    - 16（0x10）：只检查在预设清单(sortlists.xlsx)里面tvorder<9999的节目,除此之外，允许关键字清单的节目（参数keywords）加入。该功能比较有用，大多数人只要看cctv和各大卫视节目外，还有就是本地的其他节目。那么sortlists里面保存所有cctv和各大卫视节目名称外，本地其他节目可用keywords包括，比如关键字['赣州']。
    - 以上功能可以组合，比如ctype=0x1+0x2+0x10=19，表明同时检查本地/外部/预设清单过滤的节目。

- -`checkfile_list`:外部文件地址清单。（ctype包含0x2时需要）
    - 可以是http/https地址
    - 也可以是本地文件地址

- -`otype`:检测结果输出格式，输出后需要拷贝到其他地方请搭配sendfile_list参数使用
    - 0x1：diyp播放器格式
    - 0x2：标准m3u格式
    - 0x4：标准txt格式
    - 组合，以上可以组合输出多个格式

- -`sendfile_list`:检测结果同步拷贝到目的地列表
    - 文件列表，长度与次序都必须与otype参数一致，如果某个格式不需要拷贝，则设为""
  
- -以下参数可选
  
  - -`max_check_count`：最大检测节目数量，默认是2000个
  
  - -`webhook`：填入钉钉群自定义机器人的token，可以不配置即关闭
  ```
   "webhook": "https://oapi.dingtalk.com/robot/send?access_token=这里填写自己钉钉群自定义机器人的token"
  ```
  - -`secret`：创建机器人勾选“加签”选项所设置的密钥，同上
  ```
    "secret":"SEC11b9...这里填写自己的加密设置密钥"  # 创建机器人勾选“加签”选项时使用
  ```
  - -`your_domain`：生成的excel文件所在服务器域名/ip,修改main.py 注意添加 http / https
  ```
    `your_domain` = 'https://list.domain.com'
  ```

  - -`playlist_file`:修改main.py ，调整本地直播源源文件存放路径（playlists）文件位置
  ```
   `playlist_file` = 'playlists/' 
  ```
  
  - -`delay_threshold`:响应延迟阈值，单位毫秒，超过这个阈值则认为直播源质量较差
  ```
   `delay_threshold` = 6000  
  ```

- 钉钉群机器人配置（可选）

  - 群设置->智能群助手->添加机器人->添加机器人->自定义->添加
  - 获得`secret`  <img src="https://ae01.alicdn.com/kf/Uafc4e58d1f1746d5ae834f3e0bc38227i.jpg" height = "400" alt="secret" align=center />
  
  - 获得`webhook`  <img src="https://ae01.alicdn.com/kf/U78defb7a5d954af5ae962d4b40b81d34D.jpg" height = "400" alt="secret" align=center />
  
  
## 运行
```
  python main.py

  为了方便没有python环境的用户(Windows),已经编译成exe文件，直接下载main.rar，解压后运行main.exe即可。
```

## 常用参数配置(myconfig.json)

- 只检测本地文件：
```
{
    "testspeed":1,
    "ctype":1,
}
```

- 检测外部文件，同时按sortlists.xlsx文件进行限制：
```
{
    "testspeed":1,
    "ctype":18,
    "checkfile_list":["https://github.com/users/project1/raw/master/iptv.txt",
                      "C:\\Users\\admin\\Desktop\\live.m3u"],
    "otype":7,
    "keywords":["江西"]
  }
```

- sortlists.xlsx文件修改：

  |title     | tvgroup |uniquename| url             | memo  | tvorder |
  |-------   | --------|----------|-------------    |-------|---------|
  |CCTV-1综合| 1.央视   | CCTV-1   |https:///url1.com|       |   1     |
  |CCTV-1    | 1.央视   | CCTV-1   |https:///url2.com|       |   1     |
  |CCTV1     | 1.央视   | CCTV-1   |https:///url3.com|       |   1     |
  |CCTV1 HD  | 1.央视   | CCTV-1   |https:///url4.com|       |   1     |
  |CCTV-2    | 1.央视   | CCTV-2   |https:///url5.com|       |   2     |
  |四海钓鱼   | 1.央视   | 四海钓鱼  |https:///url6.com|       |   9999  |

  注意：
    - 同一个节目频道（比如cctv-1），uniquename和tvorder必须相同。其中uniquename是最终显示的节目名称 
    - 同一个节目频道（比如cctv-1），title最好都慢慢搜录进来，避免搜索的时候因为不在这个xls文件列表清单内而被剔除
    - 检测时，系统会自动对url相同的进行去重，只保留一个，哪一个？我也不知道。
    - tvorder=9999, 默认不检测该节目

- 也可配合crontab等定时执行
```
* 检测直链时，自动下载至playlists/，而后检测该目录下所有文件
```

## 注意事项

使用Nginx或Apache等，请注意增加对除了`.xlsx`外文件的访问权限，以免数据丢失

nginx可使用如下配置
```
location ~ \.(py|pyc|txt|sqlite3)$ {
      deny all;
} 
```

## 待优化内容
- 增加对输出copy的支持（支持ssh/ftp等网络方式）
- 增加对微信推送的支持
- ……
