#!/bin/bash

cd $(dirname $0);
cd ../;
echo "check duocang......"

cd duocang;
> ys_duocang_update.sql;
> ys_duocang_update.sqltmp;
> zb_duocang_update.sql;
> zb_duocang_update.sqltmp;
> duocang.listtmp;
echo '{}'> duocang.json;

#duocangjuhe
while read line|| [[ -n $line ]];
do
    api_name=`echo -n ${line}|awk '{print$1}'`
    api_url=`echo -n ${line}|awk '{print$2}'`
    echo ${api_name} ${api_url}
    	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
    python ../scripts/analyse_json.py ${api_url} 'add' >>duocang.listtmp;


done < juhe.list

sed -i 's#https://ghproxy.net/##g' duocang.listtmp;

echo '' >>duocang.listtmp
id_num=1
cat duocang.listtmp|sort|uniq|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'|sed 's/[^[:alpha:]]//g'`
    api_url=`echo -n ${line}|awk '{print$2}'`
	
	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
	  response='999'
    # echo "start check ${api_url}......"
    # response=$( curl -s -L --max-time 10 "$api_url"|grep key|grep name|wc -l)

    if [[ $response -gt 10  ]]; then
      echo "URL is accessible"

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> ys_duocang_update.sqltmp
      echo "INSERT into iptv.dsmtv_movie(id, name, api, state) select '${id_num}','${api_name}','${api_url}','1';" >> zb_duocang_update.sqltmp
      id_num=$((id_num+1))


    else
      echo "URL is unaccessible,ignore update"
    fi
done 

 rm -f duocang.listtmp;


while read line|| [[ -n $line ]];
do
    api_name=`echo -n ${line}|awk '{print$1}'`
    api_url=`echo -n ${line}|awk '{print$2}'`
	
	if [ "${api_name}" == "" ] || [ "${api_url}" == "" ];then
	   continue
	fi
	  response='200'
    # echo "start check ${api_url}......"
    # response=$(curl -o /dev/null -L -s -w "%{http_code}" --max-time 10 "$api_url")

    if [[ $response -ge 200 && $response -lt 400 ]]; then

      echo "URL is accessible"

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> ys_duocang_update.sqltmp
      echo "INSERT into iptv.dsmtv_movie(id, name, api, state) select '${id_num}','${api_name}','${api_url}','1';" >> zb_duocang_update.sqltmp
      id_num=$((id_num+1))


    else
      echo "URL is unaccessible,ignore update"
    fi
done < api.list

check_res=`cat ys_duocang_update.sqltmp|sort|uniq|wc -l`

if [ "${check_res}" -ne "0" ];then
  #qunhuiyingshi
  echo "set character_set_server='utf8';" >> ys_duocang_update.sql;
  echo "SET FOREIGN_KEY_CHECKS = 0;" >> ys_duocang_update.sql;
  echo "delete from tvbox.tv_app_duocang;" >> ys_duocang_update.sql;

  #echo "UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';" >> ys_duocang_update.sql;
  cat ys_duocang_update.sqltmp|sort|uniq >> ys_duocang_update.sql;
  echo "SET FOREIGN_KEY_CHECKS = 1;" >> ys_duocang_update.sql;
  echo "commit;" >> ys_duocang_update.sql;


  #qunhuizhibo
  echo "set character_set_server='utf8';" >> zb_duocang_update.sql;
  echo "SET FOREIGN_KEY_CHECKS = 0;" >> zb_duocang_update.sql;
  echo "delete from iptv.dsmtv_movie;" >> zb_duocang_update.sql;
  cat zb_duocang_update.sqltmp|sort|uniq >> zb_duocang_update.sql;
  echo "SET FOREIGN_KEY_CHECKS = 1;" >> zb_duocang_update.sql;
  echo "commit;" >> zb_duocang_update.sql;
fi
  rm -f ys_duocang_update.sqltmp;
  rm -f zb_duocang_update.sqltmp;


cd ../;