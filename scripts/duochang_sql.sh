#!/bin/bash
cd $(dirname $0);
cd ../;
echo "check duochang......"

cd duochang;
> duochang_update.sql;
> duochang_update.sqltmp;
cat api.list|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'`
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

check_res=`cat duochang_update.sqltmp|sort|uniq|wc -l`

if [ "${check_res}" -ne "0" ];then

  echo "set character_set_server='utf8';" >> duochang_update.sql;
  echo "UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';" >> duochang_update.sql;
  cat duochang_update.sqltmp >> duochang_update.sql;
fi
  rm -f duochang_update.sqltmp;
cd ../;



