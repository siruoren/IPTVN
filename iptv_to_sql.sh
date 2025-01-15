#!/bin/bash
cd IPTV;
> IPTV_update.sqltmp;
for m3u_file in `ls|grep '.m3u'`
do  

echo ${m3u_file}
group_name=`echo ${m3u_file}|awk -F '.m3u' '{print$1}' `
echo "INSERT  into tvbox.tv_category(name,enable,type) (select '${group_name}','1','default' from tvbox.tv_category where not EXISTS (SELECT name from tvbox.tv_category WHERE name='${group_name}')limit 1);" >> IPTV_update.sqltmp

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
    			item_group=`sed -n "${line_nu}p" ${m3u_file}|awk -F'group-title=' '{print$2}'|awk '{printf$1}' |sed 's/"//g'|awk -F',' '{printf$1}'`
    			item_url=`sed -n "${line_next}p" ${m3u_file}|grep '^http'`
    			
    			echo "INSERT into tvbox.tv_channels(name,category,url) values('${item_id}','${item_group}','${item_url}');" >> IPTV_update.sqltmp
    			i=` expr $i + 1 `
    	    fi
    	fi

     fi
    done

done
> IPTV_update.sql;
echo "set character_set_server='utf8';" >> IPTV_update.sql;
echo "TRUNCATE table tvbox.tv_channels;" >> IPTV_update.sql;
cat IPTV_update.sqltmp >> IPTV_update.sql;
rm -f IPTV_update.sqltmp;
cd ../;

echo "check duochang......"

cd duochang;
> duochang_update.sql;
cat api.list|while read line;
do
    api_name=`echo -n ${line}|awk '{print$1}'`
    api_url=`echo -n ${line}|awk '{print$2}'`
	
	if [ "${api_name}" == ""|| "${api_url}" == "" ];then
	   continue
	fi
	
    echo "start check ${api_url}......"
    response=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 "$api_url")

    if [[ $response -ge 200 && $response -lt 400 ]]; then
      echo "URL is accessible"

      echo "INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '${api_name}','${api_url}','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '${api_name}');" >> duochang_update.sqltmp



    else
      echo "unaccessible"
    fi
done

check_res=`cat duochang_update.sqltmp|sort|uniq|wc -l`

if [ "${check_res}" -ne "0" ];then

  echo "set character_set_server='utf8';" >> duochang_update.sql;
  cat duochang_update.sqltmp >> duochang_update.sql;
fi
  rm -f duochang_update.sqltmp;
cd ../;
