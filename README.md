# 所有数据来源于互联网，内容真实性请用户自行辨认。

# 本源码仅供学习，禁止用于违法犯罪行为，否则后果自负！

# Auto Update IPTV at 2025-03-17 00:24:12 CST
----------------------------------------------------
#!/bin/bash
cd $(dirname $0);
# 源
> ../IPTV.m3u

while read line
do

src_name=`echo $line|awk '{print$1}'`
src_url=`echo $line|awk '{print$2}'`
wget ${src_url} -O ${src_name}.m3u;cat ${src_name}.m3u >> ../IPTV.m3u;rm -f ${src_name}.m3u;


done < iptv_src.list;
--2025-03-17 00:24:12--  https://raw.githubusercontent.com/Guovin/iptv-api/gd/output/result.m3u
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 523324 (511K) [text/plain]
Saving to: ‘Guovin.m3u’

     0K .......... .......... .......... .......... ..........  9% 7.79M 0s
    50K .......... .......... .......... .......... .......... 19% 23.2M 0s
   100K .......... .......... .......... .......... .......... 29% 16.2M 0s
   150K .......... .......... .......... .......... .......... 39% 52.9M 0s
   200K .......... .......... .......... .......... .......... 48% 34.4M 0s
   250K .......... .......... .......... .......... .......... 58% 18.0M 0s
   300K .......... .......... .......... .......... .......... 68%  177M 0s
   350K .......... .......... .......... .......... .......... 78%  243M 0s
   400K .......... .......... .......... .......... .......... 88% 61.1M 0s
   450K .......... .......... .......... .......... .......... 97% 37.9M 0s
   500K .......... .                                          100% 20.6T=0.02s

2025-03-17 00:24:12 (26.3 MB/s) - ‘Guovin.m3u’ saved [523324/523324]

--2025-03-17 00:24:13--  https://raw.githubusercontent.com/fanmingming/live/main/tv/m3u/ipv6.m3u
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.108.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 48434 (47K) [text/plain]
Saving to: ‘fangming.m3u’

     0K .......... .......... .......... .......... .......   100% 8.93M=0.005s

2025-03-17 00:24:13 (8.93 MB/s) - ‘fangming.m3u’ saved [48434/48434]

--2025-03-17 00:24:13--  https://raw.githubusercontent.com/vbskycn/iptv/refs/heads/master/tv/iptv4.m3u
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.108.133, 185.199.111.133, 185.199.110.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 587133 (573K) [text/plain]
Saving to: ‘vbskycn_iptv4.m3u’

     0K .......... .......... .......... .......... ..........  8% 8.92M 0s
    50K .......... .......... .......... .......... .......... 17% 24.0M 0s
   100K .......... .......... .......... .......... .......... 26% 12.1M 0s
   150K .......... .......... .......... .......... .......... 34% 75.5M 0s
   200K .......... .......... .......... .......... .......... 43% 11.6M 0s
   250K .......... .......... .......... .......... .......... 52%  170M 0s
   300K .......... .......... .......... .......... .......... 61%  189M 0s
   350K .......... .......... .......... .......... .......... 69% 58.3M 0s
   400K .......... .......... .......... .......... .......... 78%  149M 0s
   450K .......... .......... .......... .......... .......... 87%  102M 0s
   500K .......... .......... .......... .......... .......... 95% 16.6M 0s
   550K .......... .......... ...                             100% 55.3M=0.02s

2025-03-17 00:24:13 (25.5 MB/s) - ‘vbskycn_iptv4.m3u’ saved [587133/587133]

--2025-03-17 00:24:13--  https://raw.githubusercontent.com/vbskycn/iptv/refs/heads/master/tv/iptv6.m3u
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.110.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16929 (17K) [text/plain]
Saving to: ‘vbskycn_iptv6.m3u’

     0K .......... ......                                     100% 38.6M=0s

2025-03-17 00:24:13 (38.6 MB/s) - ‘vbskycn_iptv6.m3u’ saved [16929/16929]





rm -rf ../IPTV;
mkdir -p ../IPTV;cd ../IPTV
cat ../IPTV.m3u |grep 'group-title'|awk -F ',' '{print$1}'|awk '{print$NF}'|grep "^group"|sort|uniq|awk -F'"' '{print$2}'|xargs -i touch {}.m3u
for i in `ls`; do group_name=`echo ${i}|awk -F '.' '{print$1}'`; grep -A 1 "${group_name}" ../IPTV.m3u > ${i}; done
cd ../
# 节目源
rm -f EPG.xml && wget https://epg.112114.xyz/pp.xml -O EPG.xml
--2025-03-17 00:24:13--  https://epg.112114.xyz/pp.xml
Resolving epg.112114.xyz (epg.112114.xyz)... 172.67.203.219, 104.21.85.82
Connecting to epg.112114.xyz (epg.112114.xyz)|172.67.203.219|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2083868 (2.0M) [text/xml]
Saving to: ‘EPG.xml’

     0K .......... .......... .......... .......... ..........  2%  116M 0s
    50K .......... .......... .......... .......... ..........  4% 8.80M 0s
   100K .......... .......... .......... .......... ..........  7% 10.4M 0s
   150K .......... .......... .......... .......... ..........  9% 47.5M 0s
   200K .......... .......... .......... .......... .......... 12%  154M 0s
   250K .......... .......... .......... .......... .......... 14% 11.0M 0s
   300K .......... .......... .......... .......... .......... 17% 77.2M 0s
   350K .......... .......... .......... .......... .......... 19%  224M 0s
   400K .......... .......... .......... .......... .......... 22%  315M 0s
   450K .......... .......... .......... .......... .......... 24%  318M 0s
   500K .......... .......... .......... .......... .......... 27% 98.5M 0s
   550K .......... .......... .......... .......... .......... 29%  297M 0s
   600K .......... .......... .......... .......... .......... 31% 14.6M 0s
   650K .......... .......... .......... .......... .......... 34%  140M 0s
   700K .......... .......... .......... .......... .......... 36%  264M 0s
   750K .......... .......... .......... .......... .......... 39%  152M 0s
   800K .......... .......... .......... .......... .......... 41%  219M 0s
   850K .......... .......... .......... .......... .......... 44%  270M 0s
   900K .......... .......... .......... .......... .......... 46%  224M 0s
   950K .......... .......... .......... .......... .......... 49%  201M 0s
  1000K .......... .......... .......... .......... .......... 51%  243M 0s
  1050K .......... .......... .......... .......... .......... 54% 93.0M 0s
  1100K .......... .......... .......... .......... .......... 56%  351M 0s
  1150K .......... .......... .......... .......... .......... 58%  106M 0s
  1200K .......... .......... .......... .......... .......... 61%  348M 0s
  1250K .......... .......... .......... .......... .......... 63%  194M 0s
  1300K .......... .......... .......... .......... .......... 66%  219M 0s
  1350K .......... .......... .......... .......... .......... 68%  139M 0s
  1400K .......... .......... .......... .......... .......... 71%  323M 0s
  1450K .......... .......... .......... .......... .......... 73% 38.0M 0s
  1500K .......... .......... .......... .......... .......... 76%  311M 0s
  1550K .......... .......... .......... .......... .......... 78%  137M 0s
  1600K .......... .......... .......... .......... .......... 81%  106M 0s
  1650K .......... .......... .......... .......... .......... 83%  309M 0s
  1700K .......... .......... .......... .......... .......... 85%  285M 0s
  1750K .......... .......... .......... .......... .......... 88%  254M 0s
  1800K .......... .......... .......... .......... .......... 90%  245M 0s
  1850K .......... .......... .......... .......... .......... 93%  257M 0s
  1900K .......... .......... .......... .......... .......... 95%  204M 0s
  1950K .......... .......... .......... .......... .......... 98%  196M 0s
  2000K .......... .......... .......... .....                100%  273M=0.03s

2025-03-17 00:24:13 (67.3 MB/s) - ‘EPG.xml’ saved [2083868/2083868]


#iptv_to_sql


default_assign_first="央视频道,卫视频道,电影频道,经典剧场,动画频道,音乐频道,体育频道,游戏频道,港澳台,"
default_assign_second="山东频道,北京频道,吉林频道,上海频道,云南频道,四川频道,天津频道,宁夏频道,安徽频道,山西频道,广东频道,广西频道,新疆频道,江苏频道,河北频道,河南频道,浙江频道,湖北频道,湖南频道,甘肃频道,福建频道,贵州频道,辽宁频道,重庆频道,陕西频道,青海频道,黑龙江频道,内蒙频道"

exclude_pd="其他频道,地方频道,解说频道,春晚频道,体验频道,央视付费频道,咪咕直播,更新时间,"


cd IPTV;
> IPTV_update.sqltmp;
for m3u_file in `ls|grep '.m3u'`
do  

echo ${m3u_file}
group_name=`echo ${m3u_file}|awk -F '.m3u' '{print$1}'|sed 's/[^[:alpha:]]//g'`
echo "INSERT  into tvbox.tv_category(name,enable,type) (select '${group_name}','1','default' from tvbox.tv_category where not EXISTS (SELECT name from tvbox.tv_category WHERE name='${group_name}')limit 1);" >> IPTV_update.sqltmp
if [[ ${default_assign_first} =~ ${group_name} ]] || [[ ${default_assign_second} =~ ${group_name} ]];then
    echo "${group_name} has in there default assign......"
else
    if [[ ${exclude_pd} =~ ${group_name} ]]; then
       echo "${group_name} is in exclude_pd,not assign!!!!"
    else
      default_assign_first=`echo ${default_assign_first}${group_name},`
    fi
fi


    lines_num=`wc -l ${m3u_file}|awk '{printf$1}'`
    for (( i=1;i<${lines_num};i++ ))
    do 
        line_nu=$i
        line_next=` expr $i + 1 `
        #echo $line_nu
        #echo $line_next
        
        #echo `sed -n "${line_nu}p" ${m3u_file}|grep '^#'`
        check_id=`sed -n "${line_nu}p" ${m3u_file}|grep '^#'|wc -l`
        if [ ` sed -n "${line_nu}p" ${m3u_file}|grep -E "4K|8K|欧洲|美洲"|wc -l `  -eq "0" ];then
           
        if [ "${check_id}" -ne 0 ];then
    	    #echo  `sed -n "${line_next}p" ${m3u_file}|grep '^http'`
    	    check_url=`sed -n "${line_next}p" ${m3u_file}|grep '^http'|wc -l`
    	    if [[ "${check_url}" -ne 0 ]];then
    		      item_id=`sed -n "${line_nu}p" ${m3u_file}|awk -F'tvg-name=' '{print$2}'|awk '{printf$1}' |sed 's/"//g'`
    			    item_group=`sed -n "${line_nu}p" ${m3u_file}|awk -F'group-title=' '{print$2}'|awk '{printf$1}' |sed 's/"//g'|awk -F',' '{printf$1}'|sed 's/[^[:alpha:]]//g'`
    			    item_url=`sed -n "${line_next}p" ${m3u_file}|grep '^http'`
    			    echo "INSERT into tvbox.tv_channels(name,category,url) select '${item_id}','${item_group}','${item_url}' where NOT EXISTS (SELECT 1 FROM tvbox.tv_channels WHERE url='${item_url}');" >> IPTV_update.sqltmp
    			    i=` expr $i + 1 `
    	    fi
    	fi

     fi
    done

done
☘️上海频道.m3u
上海频道 has in there default assign......
☘️云南频道.m3u
云南频道 has in there default assign......
☘️内蒙古频道.m3u
☘️北京频道.m3u
北京频道 has in there default assign......
☘️吉林频道.m3u
吉林频道 has in there default assign......
☘️四川频道.m3u
四川频道 has in there default assign......
☘️天津频道.m3u
天津频道 has in there default assign......
☘️宁夏频道.m3u
宁夏频道 has in there default assign......
☘️安徽频道.m3u
安徽频道 has in there default assign......
☘️山东频道.m3u
山东频道 has in there default assign......
☘️山西频道.m3u
山西频道 has in there default assign......
☘️广东频道.m3u
广东频道 has in there default assign......
☘️广西频道.m3u
广西频道 has in there default assign......
☘️新疆频道.m3u
新疆频道 has in there default assign......
☘️江苏频道.m3u
江苏频道 has in there default assign......
☘️河北频道.m3u
河北频道 has in there default assign......
☘️河南频道.m3u
河南频道 has in there default assign......
☘️浙江频道.m3u
浙江频道 has in there default assign......
☘️海南频道.m3u
☘️湖北频道.m3u
湖北频道 has in there default assign......
☘️湖南频道.m3u
湖南频道 has in there default assign......
☘️甘肃频道.m3u
甘肃频道 has in there default assign......
☘️福建频道.m3u
福建频道 has in there default assign......
☘️贵州频道.m3u
贵州频道 has in there default assign......
☘️辽宁频道.m3u
辽宁频道 has in there default assign......
☘️重庆频道.m3u
重庆频道 has in there default assign......
☘️陕西频道.m3u
陕西频道 has in there default assign......
☘️青海频道.m3u
青海频道 has in there default assign......
☘️黑龙江频道.m3u
黑龙江频道 has in there default assign......
体育频道.m3u
体育频道 has in there default assign......
体验频道.m3u
体验频道 is in exclude_pd,not assign!!!!
儿童频道.m3u
其他频道.m3u
其他频道 is in exclude_pd,not assign!!!!
内蒙频道.m3u
内蒙频道 has in there default assign......
卫视频道.m3u
卫视频道 has in there default assign......
地方频道.m3u
地方频道 is in exclude_pd,not assign!!!!
央视频道.m3u
央视频道 has in there default assign......
戏曲频道.m3u
数字频道.m3u
春晚频道.m3u
春晚频道 is in exclude_pd,not assign!!!!
更新时间.m3u
更新时间 is in exclude_pd,not assign!!!!
浙江频道.m3u
浙江频道 has in there default assign......
游戏频道.m3u
游戏频道 has in there default assign......
电影频道.m3u
电影频道 has in there default assign......
直播中国.m3u
纪录频道.m3u
综艺频道.m3u
解说频道.m3u
解说频道 is in exclude_pd,not assign!!!!
音乐频道.m3u
音乐频道 has in there default assign......
🌊港·澳·台.m3u
港澳台 has in there default assign......
🎥咪咕直播.m3u
咪咕直播 is in exclude_pd,not assign!!!!
🎬电影频道.m3u
电影频道 has in there default assign......
🎮游戏频道.m3u
游戏频道 has in there default assign......
🎵音乐频道.m3u
音乐频道 has in there default assign......
🏀体育频道.m3u
体育频道 has in there default assign......
🏛经典剧场.m3u
经典剧场 has in there default assign......
💰央视付费频道.m3u
央视付费频道 is in exclude_pd,not assign!!!!
📡卫视频道.m3u
卫视频道 has in there default assign......
📺央视频道.m3u
央视频道 has in there default assign......
🕘️更新时间.m3u
更新时间 is in exclude_pd,not assign!!!!
🪁动画频道.m3u
动画频道 has in there default assign......
> IPTV_update.sql;
echo "set character_set_server='utf8';" >> IPTV_update.sql;
echo "TRUNCATE table tvbox.tv_channels;" >> IPTV_update.sql;
echo "INSERT into tvbox.tv_channels(name,category,url) values('default', 'default', 'default');" >> IPTV_update.sql;
echo "SELECT SLEEP(5);" >> IPTV_update.sql;
cat IPTV_update.sqltmp|grep -iE "总台|央视"|grep -v '\\'|grep -v liveshow >> IPTV_update.sql;
cat IPTV_update.sqltmp|grep -ivE "总台|央视"|grep -v '\\' >> IPTV_update.sql;
echo "DELETE FROM tvbox.tv_channels where name='default';" >> IPTV_update.sql;
default_assign_all="${default_assign_first}${default_assign_second}"

#添加自动赋权
echo "UPDATE tvbox.tv_meals SET mealname='默认套餐', listinfo='${default_assign_all}' WHERE id=1;" >> IPTV_update.sql;

rm -f IPTV_update.sqltmp;
cd ../;
#!/bin/bash
cd $(dirname $0);
cd ../;
echo "check duochang......"
check duochang......

cd duochang;
> duochang_update.sql;
> duochang_update.sqltmp;
> duochang.listtmp;

#duochangjuhe
cat juhe.list|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'`
    api_url=`echo -n ${line}|awk '{print$2}'`
    echo ${api_name} ${api_url}
    	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
    python ../scripts/analyse_json.py ${api_url} 'add' >>duochang.listtmp;


done
欧歌聚合 https://m.nxog.top/nxog/ou1.php
Traceback (most recent call last):
  File "/usr/lib/python3.12/urllib/request.py", line 1344, in do_open
    h.request(req.get_method(), req.selector, req.data, headers,
  File "/usr/lib/python3.12/http/client.py", line 1336, in request
    self._send_request(method, url, body, headers, encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1382, in _send_request
    self.endheaders(body, encode_chunked=encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1331, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1091, in _send_output
    self.send(msg)
  File "/usr/lib/python3.12/http/client.py", line 1035, in send
    self.connect()
  File "/usr/lib/python3.12/http/client.py", line 1477, in connect
    self.sock = self._context.wrap_socket(self.sock,
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/ssl.py", line 455, in wrap_socket
    return self.sslsocket_class._create(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/ssl.py", line 1042, in _create
    self.do_handshake()
  File "/usr/lib/python3.12/ssl.py", line 1320, in do_handshake
    self._sslobj.do_handshake()
ConnectionResetError: [Errno 104] Connection reset by peer

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 15, in <module>
    main(item)
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 8, in main
    response = urllib.request.urlopen(url,timeout=10.0)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 215, in urlopen
    return opener.open(url, data, timeout)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 515, in open
    response = self._open(req, data)
               ^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 532, in _open
    result = self._call_chain(self.handle_open, protocol, protocol +
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 492, in _call_chain
    result = func(*args)
             ^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 1392, in https_open
    return self.do_open(http.client.HTTPSConnection, req,
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 1347, in do_open
    raise URLError(err)
urllib.error.URLError: <urlopen error [Errno 104] Connection reset by peer>
七星线路 https://qixing.myhkw.com/DC.txt
宝盒视界 https://raw.githubusercontent.com/guot55/yg/main/ysdc.json
天微精选仓 https://qixing.myhkw.com/DC.txt
毒药 https://tv.youdu.fan:666
小盒子多仓 http://xhztv.top/tvbox.txt
星河多仓 http://52bsj.vip:81/api/v3/file/get/65430/zongcang.txt?sign=9ncAS6eZ86xmIZGf5FGGdNuBvztyubgFNamtypebe08%3D%3A0
Traceback (most recent call last):
  File "/usr/lib/python3.12/urllib/request.py", line 1344, in do_open
    h.request(req.get_method(), req.selector, req.data, headers,
  File "/usr/lib/python3.12/http/client.py", line 1336, in request
    self._send_request(method, url, body, headers, encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1382, in _send_request
    self.endheaders(body, encode_chunked=encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1331, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/lib/python3.12/http/client.py", line 1091, in _send_output
    self.send(msg)
  File "/usr/lib/python3.12/http/client.py", line 1035, in send
    self.connect()
  File "/usr/lib/python3.12/http/client.py", line 1001, in connect
    self.sock = self._create_connection(
                ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/socket.py", line 852, in create_connection
    raise exceptions[0]
  File "/usr/lib/python3.12/socket.py", line 837, in create_connection
    sock.connect(sa)
TimeoutError: timed out

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 15, in <module>
    main(item)
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 8, in main
    response = urllib.request.urlopen(url,timeout=10.0)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 215, in urlopen
    return opener.open(url, data, timeout)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 515, in open
    response = self._open(req, data)
               ^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 532, in _open
    result = self._call_chain(self.handle_open, protocol, protocol +
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 492, in _call_chain
    result = func(*args)
             ^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 1373, in http_open
    return self.do_open(http.client.HTTPConnection, req)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 1347, in do_open
    raise URLError(err)
urllib.error.URLError: <urlopen error timed out>
业余打发多仓 https://raw.githubusercontent.com/yyfxz/qqtv/main/qq.json
运输车多仓 https://weixine.net/api.json
Traceback (most recent call last):
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 15, in <module>
    main(item)
  File "/home/runner/work/IPTVN/IPTVN/duochang/../scripts/analyse_json.py", line 8, in main
    response = urllib.request.urlopen(url,timeout=10.0)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 215, in urlopen
    return opener.open(url, data, timeout)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 521, in open
    response = meth(req, response)
               ^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 630, in http_response
    response = self.parent.error(
               ^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 559, in error
    return self._call_chain(*args)
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 492, in _call_chain
    result = func(*args)
             ^^^^^^^^^^^
  File "/usr/lib/python3.12/urllib/request.py", line 639, in http_error_default
    raise HTTPError(req.full_url, code, msg, hdrs, fp)
urllib.error.HTTPError: HTTP Error 403: Forbidden
影视线路 https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/%E5%BD%B1%E8%A7%86%E7%BA%BF%E8%B7%AF.txt
网络名家 https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/%E7%BD%91%E7%BB%9C%E5%90%8D%E5%AE%B6.txt




sed -i 's#https://ghproxy.net/##g' duochang.listtmp;

cat duochang.listtmp|sort|uniq|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'|sed 's/[^[:alpha:]]//g'`
    api_url=`echo -n ${line}|awk '{print$2}'`
	
	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
	
    echo "start check ${api_url}......"
    response=$( curl -s -L --max-time 10 "$api_url"|grep key|grep name|wc -l)

    if [[ $response -gt 10  ]]; then
      echo "URL is accessible"

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> duochang_update.sqltmp



    else
      echo "URL is unaccessible,ignore update"
    fi
done
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/CandyMuj.txt......
URL is accessible
start check https://download.kstore.space/download/2883/nzk/nzk0722.json......
URL is unaccessible,ignore update
start check https://download.kstore.space/download/2883/nzk/nzk0722.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/Moew.txt......
URL is accessible
start check https://play.iptv365.org/OK/api.json......
URL is unaccessible,ignore update
start check https://gitee.com/okjack/okk/raw/master/op.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/PG/api.json......
URL is unaccessible,ignore update
start check https://git.acwing.com/iduoduo/orange/-/raw/main/jsm.json......
URL is unaccessible,ignore update
start check https://mirror.ghproxy.com/https://raw.githubusercontent.com/guot55/yg/main/pg2/jsm.json......
URL is unaccessible,ignore update
start check https://100km.top/0......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/dxawi.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/iptv365/api.json......
URL is unaccessible,ignore update
start check http://ok321.top/tv......
URL is unaccessible,ignore update
start check https://gitcode.net/ygbh66/yg/-/raw/main/pg/bh2.json......
URL is unaccessible,ignore update
start check https://www.gitlink.org.cn/attachments/entries/get_file?download_url=https://www.gitlink.org.cn/api/guot55/yg/raw/pg%2Fjsm.json?ref=main......
URL is unaccessible,ignore update
start check https://yydf.540734621.xyz/QQ/yydf2024.json......
URL is unaccessible,ignore update
start check http://itvbox.cc/云星日记......
URL is unaccessible,ignore update
start check http://itvbox.cc/tvbox/云星日记/1.m3u8......
URL is unaccessible,ignore update
start check http://64.112.42.49:1688/https://raw.githubusercontent.com/guot55/yg/main/pg/jsm.json......
URL is unaccessible,ignore update
start check https://毒盒.com/tv......
URL is unaccessible,ignore update
start check https://play.iptv365.org/动漫频道/api.json......
URL is unaccessible,ignore update
start check https://play.iptv365.org/南风/api.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yoursmile66/TVBox/main/XC.json......
URL is accessible
start check http://52pan.top:81/api/v3/file/get/174964/%E5%90%BE%E7%88%B1%E8%AF%84%E6%B5%8B.m3u?sign=rPssLoffquDXszCARt6UNF8MobSa1FA27XomzOluJBY%3D%3A0......
URL is unaccessible,ignore update
start check http://52pan.top:81/api/v3/file/get/174964/%E5%90%BE%E7%88%B1%E8%AF%84%E6%B5%8B.m3u?sign=rPssLoffquDXszCARt6UNF8MobSa1FA27XomzOluJBY%3D%3A0......
URL is unaccessible,ignore update
start check http://meowtv.cn/tv......
URL is accessible
start check http://meowtv.top/tv......
URL is accessible
start check https://codeberg.org/Xym/ymz/raw/branch/main/夜猫子......
URL is unaccessible,ignore update
start check http://ttkx.live:55/天天开心......
URL is unaccessible,ignore update
start check https://play.iptv365.org/天天开心/api.json......
URL is unaccessible,ignore update
start check https://play.iptv365.org/天微/api.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/小米.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/小米/api.json......
URL is unaccessible,ignore update
start check http://xhww.fun:63/小米/DEMO.json......
URL is unaccessible,ignore update
start check https://play.iptv365.org/少儿频道/api.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/巧技.txt......
URL is unaccessible,ignore update
start check http://rihou.vip:55/天天开心......
URL is unaccessible,ignore update
start check https://weixine.net/ysc.json......
URL is unaccessible,ignore update
start check https://play.iptv365.org/戏曲音乐/api.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/挺好.txt......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/摸鱼.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/摸鱼儿/api.json......
URL is unaccessible,ignore update
start check http://tvbox.王二小放牛娃.xyz......
URL is unaccessible,ignore update
start check http://www.wya6.cn/tv/yc.json......
URL is unaccessible,ignore update
start check https://fmbox.cc......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/星辰.txt......
URL is unaccessible,ignore update
start check https://gitlab.com/guot55/bh/-/raw/main/pg/bh.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/欧歌.txt......
URL is accessible
start check https://play.iptv365.org/欧歌/api.json......
URL is unaccessible,ignore update
start check https://xn--tkh-mf3g9f.v.nxog.top/m/111.php?ou=公众号欧歌app&mz=index&jar=index&123&b=欧歌tkh......
URL is accessible
start check http://o.nxog.top/m/111.php?ou=公众号欧歌app&mz=index&jar=index&123&b=欧歌......
URL is unaccessible,ignore update
start check https://play.iptv365.org/潇洒/api.json......
URL is unaccessible,ignore update
start check http://tv.999888987.xyz/......
URL is unaccessible,ignore update
start check https://play.iptv365.org/王二小/api.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/王二小放牛娃.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/白嫖/api.json......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/盒子迷.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/短剧频道/api.json......
URL is unaccessible,ignore update
start check http://dp.sxtv.top:88/img......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/南风.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/js.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/py.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/饭太硬.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/肥猫.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/夜猫子.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/运输车.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/dxawi.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/多多.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/香雅情.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/菜妮丝.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/yyfxz/qqtv/main/巧儿.json......
URL is unaccessible,ignore update
start check http://肥猫.com......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/肥猫.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/肥猫/api.json......
URL is unaccessible,ignore update
start check http://肥猫.com......
URL is unaccessible,ignore update
start check http://rihou.cc:88/荷城茶秀......
URL is unaccessible,ignore update
start check https://play.iptv365.org/菜妮丝/api.json......
URL is unaccessible,ignore update
start check https://pastebin.com/raw/5NHaxyGR......
URL is unaccessible,ignore update
start check http://www.饭太硬.com/tv/......
URL is unaccessible,ignore update
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/饭太硬.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/饭太硬/api.json......
URL is unaccessible,ignore update
start check http://www.饭太硬.com/tv......
URL is unaccessible,ignore update
start check https://play.iptv365.org/香雅情/api.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/xyq254245/xyqonlinerule/main/XYQTVBox.json......
URL is accessible
start check https://ghproxy.cc/https://raw.githubusercontent.com/adminouyang/231006/refs/heads/main/tvbox/点播源/骚零.txt......
URL is unaccessible,ignore update
start check https://play.iptv365.org/骚零/api.json......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/gaotianliuyun/gao/master/js.json......
URL is accessible
start check https://龙伊.top......
URL is unaccessible,ignore update
start check https://gh-proxy.com/https://raw.githubusercontent.com/adminouyang/231006/main/tvbox/直播源/iptv.json......
URL is unaccessible,ignore update
start check http://2883.kstore.space/nzk/nzk0722.json......
URL is unaccessible,ignore update
start check https://ghproxy.cn/https://raw.githubusercontent.com/leevi0709/one/main/jsm.json......
URL is unaccessible,ignore update
start check http://www.fish2018.us.kg/p/jsm.json......
URL is unaccessible,ignore update
start check https://11256.kstore.space/%E5%85%8D%E8%B4%B9%E5%8B%BF%E4%BC%A0.json......
URL is unaccessible,ignore update
start check http://home.jundie.top:81/top98.json......
URL is unaccessible,ignore update
start check http://home.jundie.top:81/top98.json......
URL is unaccessible,ignore update
start check https://download.kstore.space/download/5242/冉神.json......
URL is unaccessible,ignore update
start check http://hucongrong.web3v.work/风水/fxz/fxz.json......
URL is accessible
start check https://github.moeyy.xyz/https://raw.githubusercontent.com/yoursmile66/TVBox/main/XC.json......
URL is accessible
start check http://meowtv.top/tv......
URL is accessible
start check http://t.lkkk.love/02.json......
URL is unaccessible,ignore update
start check https://7337.kstore.space/twvip/%E8%87%AA%E7%94%A8%E6%B5%8B%E8%AF%95.json......
URL is unaccessible,ignore update
start check http://mzjk.top/禁止贩卖......
URL is unaccessible,ignore update
start check http://xhztv.top/xhz.json......
URL is unaccessible,ignore update
start check http://xhztv.top/4k.json......
URL is unaccessible,ignore update
start check http://www.mpanso.com/小米/DEMO.json......
URL is unaccessible,ignore update
start check https://bitbucket.org/xduo/duoapi/raw/master/xpg.json......
URL is unaccessible,ignore update
start check https://qixing.myhkw.com/qxzj/七星智教......
URL is unaccessible,ignore update
start check http://cdn.qiaoji8.com/tvbox.json......
URL is unaccessible,ignore update
start check http://ttkx.cc:9496/开心软件......
URL is unaccessible,ignore update
start check https://www.lianyingtv.com/fast/fast......
URL is unaccessible,ignore update
start check http://175.178.251.183:6689/tv.txt......
URL is accessible
start check https://4708.kstore.space/tvbox/api.json......
URL is unaccessible,ignore update
start check http://我不是.摸鱼儿.com......
URL is unaccessible,ignore update
start check http://tvbox.王二小放牛娃.top......
URL is unaccessible,ignore update
start check https://6492.kstore.space/xnf/xnf.json......
URL is unaccessible,ignore update
start check http://www.fish2018.us.kg/z/FongMi.json......
URL is unaccessible,ignore update
start check http://74.120.175.78/JK/XYQTVBox/dj.json......
URL is accessible
start check https://github.moeyy.xyz/https://raw.githubusercontent.com/liu673cn/box/main/m.json......
URL is accessible
start check http://tv.laohu.cool/tvbox.json......
URL is unaccessible,ignore update
start check http://肥猫.live......
URL is unaccessible,ignore update
start check http://肥猫.com......
URL is unaccessible,ignore update
start check https://tv.xn--yhqu5zs87a.top......
URL is unaccessible,ignore update
start check http://tv.nxog.top/m/111.php?ou=公众号欧歌......
URL is unaccessible,ignore update
start check https://weixine.net/ysc.json......
URL is unaccessible,ignore update
start check https://gitlab.com/duomv/dzhipy/-/raw/main/index.json......
URL is unaccessible,ignore update
start check https://gitee.com/yiwu369/6758/raw/master/%E9%9D%92%E9%BE%99/1.json......
URL is unaccessible,ignore update
start check http://www.饭太硬.com/tv......
URL is unaccessible,ignore update
start check https://gh-proxy.com/https://raw.githubusercontent.com/gaotianliuyun/gao/master/XYQ.json......
URL is accessible
start check http://fmys.top/fmys.json......
URL is unaccessible,ignore update
start check https://gh-proxy.com/https://raw.githubusercontent.com/gaotianliuyun/gao/master/js.json......
URL is accessible

 rm -f duochang.listtmp;


cat api.list|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'`
    api_url=`echo -n ${line}|awk '{print$2}'`
	
	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
	
    echo "start check ${api_url}......"
    response=$(curl -o /dev/null -L -s -w "%{http_code}" --max-time 10 "$api_url")

    if [[ $response -ge 200 && $response -lt 400 ]]; then

      echo "URL is accessible"

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> duochang_update.sqltmp



    else
      echo "URL is unaccessible,ignore update"
    fi
done
start check http://影视仓.com......
URL is accessible
start check http://我不是.摸鱼儿.com......
URL is unaccessible,ignore update
start check http://ok321.top/tv......
URL is accessible
start check https://12586.kstore.space/123.json......
URL is accessible
start check https://盒子迷.top/春盈天下......
URL is accessible
start check http://pandown.pro/tvbox/tvbox.json......
URL is accessible
start check https://www.cwss.xyz/刺猬线路禁止贩卖......
URL is unaccessible,ignore update
start check http://肥猫.com......
URL is accessible
start check http://fty.xxooo.cf/tv......
URL is accessible
start check http://xhww.fun:63/小米/DEMO.json......
URL is unaccessible,ignore update
start check http://cdn.qiaoji8.com/tvbox.json......
URL is accessible
start check https://wget.la/https://raw.githubusercontent.com/xyq254245/xyqonlinerule/main/XYQTVBox.json......
URL is accessible
start check http://tv.nxog.top/m......
URL is unaccessible,ignore update
start check https://raw.githubusercontent.com/gaotianliuyun/fongmi/main/json/config.json......
URL is unaccessible,ignore update
start check http://home.jundie.top:81/top98.json......
URL is accessible
start check https://wget.la/raw.githubusercontent.com/lm317379829/PyramidStore/pyramid/py.json......
URL is unaccessible,ignore update
start check https://wget.la/https://raw.githubusercontent.com/52670576/tvbox/main/ysc.json......
URL is unaccessible,ignore update
start check http://pandown.pro/tvbox/tvbox.json......
URL is accessible
start check https://notabug.org/imbig66/tv-spider-man/raw/master/配置/0801.json......
URL is accessible
start check https://wget.la/https://raw.githubusercontent.com/dxawi/0/main/0.json......
URL is accessible
start check https://jsdelivr.pai233.top/gh/2hacc/TVBox@main/oktv.json......
URL is accessible
start check http://我不是.摸鱼儿.top......
URL is unaccessible,ignore update
start check https://wget.la/raw.githubusercontent.com/lm317379829/PyramidStore/pyramid/py.json......
URL is unaccessible,ignore update
start check https://wget.la/raw.githubusercontent.com/qist/tvbox/master/jsm.json......
URL is accessible
start check https://wget.la/https://raw.githubusercontent.com/jiushizhe/daozhang/main/drpy_dzlive6.21/index.json......
URL is accessible
start check https://wget.la/https://raw.githubusercontent.com/ls125781003/tvboxtg/main/天天开心/api.json......
URL is accessible
start check https://wget.la/raw.githubusercontent.com/gaotianliuyun/gao/master/js.json......
URL is accessible
start check https://raw.liucn.cc/box/m.json......
URL is accessible

check_res=`cat duochang_update.sqltmp|sort|uniq|wc -l`

if [ "${check_res}" -ne "0" ];then

  echo "set character_set_server='utf8';" >> duochang_update.sql;
  #echo "UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';" >> duochang_update.sql;
  cat duochang_update.sqltmp|sort|uniq >> duochang_update.sql;
fi
  rm -f duochang_update.sqltmp;


cd ../;
