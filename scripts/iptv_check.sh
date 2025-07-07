#!/bin/bash
exit 0
cd $(dirname $0);
cd ../IPTV-M3U-Checker2;
#pip3 install --user -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple;
pip3 install --user -r requirements.txt;
python3 main.py |grep 'http'|grep '3000'|awk -F'http' '{print"http"$2}'|awk -F '.m3u8' '{print$1".m38u"}'|tee check_log.txt

cat check_log.txt |grep '^http'|while read url
do
line=`echo $url|sed 's#/#\/#g'|xargs echo -n`
if [[ `cat ../IPTV.m3u|grep $line|wc -l ` != '0' ]];then
  ehco $line
  line_nu=$(expr `grep -n $line ../IPTV.m3u` + 0)
  line_bf_nu=$(expr $line_nu - 1)
  sed -i "${line_nu}d" ../IPTV.m3u
  sed -i "${line_bf_nu}d" ../IPTV.m3u
fi
done

