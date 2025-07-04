#!/bin/bash
exit 0
cd $(dirname $0);
cd ../;
echo "check duocang......"

cd duocang;
> duocang_update.sql;
> duocang_update.sqltmp;
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

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> duocang_update.sqltmp



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

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> duocang_update.sqltmp



    else
      echo "URL is unaccessible,ignore update"
    fi
done < api.list

check_res=`cat duocang_update.sqltmp|sort|uniq|wc -l`

if [ "${check_res}" -ne "0" ];then

  echo "set character_set_server='utf8';" >> duocang_update.sql;
  #echo "UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';" >> duocang_update.sql;
  cat duocang_update.sqltmp|sort|uniq >> duocang_update.sql;
fi
  rm -f duocang_update.sqltmp;


cd ../;