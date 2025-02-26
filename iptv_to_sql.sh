#!/bin/bash

# 源
> IPTV.m3u 
wget https://raw.githubusercontent.com/Guovin/iptv-api/gd/output/result.m3u -O Guovin.m3uu;cat Guovin.m3u >> IPTV.m3u;rm -f Guovin.m3u;
wget https://raw.githubusercontent.com/fanmingming/live/main/tv/m3u/ipv6.m3u -O fangming.m3u;cat fangming.m3u >> IPTV.m3u;rm -f fangming.m3u;
wget https://raw.githubusercontent.com/vbskycn/iptv/refs/heads/master/tv/iptv4.m3u -O vbskycn_iptv4.m3u;cat vbskycn_iptv4.m3u >> IPTV.m3u;rm -f vbskycn_iptv4.m3u;
wget https://raw.githubusercontent.com/vbskycn/iptv/refs/heads/master/tv/iptv6.m3u -O vbskycn_iptv6.m3u;cat vbskycn_iptv6.m3u >> IPTV.m3u;rm -f vbskycn_iptv6.m3u;







rm -rf IPTV;
mkdir -p IPTV;cd IPTV
cat ../IPTV.m3u |grep 'group-title'|awk -F ',' '{print$1}'|awk '{print$NF}'|grep "^group"|sort|uniq|awk -F'"' '{print$2}'|xargs -i touch {}.m3u
for i in `ls`; do group_name=`echo ${i}|awk -F '.' '{print$1}'`; grep -A 1 "${group_name}" ../IPTV.m3u > ${i}; done
cd ../
# 节目源
rm -f EPG.xml && wget https://epg.112114.xyz/pp.xml -O EPG.xml
echo "Auto Update IPTV in ${{ steps.date.outputs.date }}" > README.md
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
    			    echo "INSERT into tvbox.tv_channels(name,category,url) (select '${item_id}','${item_group}','${item_url}' from tvbox.tv_channels where not EXISTS(select url from tvbox.tv_channels where url='${item_url}'));" >> IPTV_update.sqltmp
    			    i=` expr $i + 1 `
    	    fi
    	fi

     fi
    done

done
> IPTV_update.sql;
echo "set character_set_server='utf8';" >> IPTV_update.sql;
echo "TRUNCATE table tvbox.tv_channels;" >> IPTV_update.sql;
cat IPTV_update.sqltmp|sort|uniq|grep -iE "总台|央视" >> IPTV_update.sql;
cat IPTV_update.sqltmp|sort|uniq|grep -ivE "总台|央视" >> IPTV_update.sql;
default_assign_all="${default_assign_first}${default_assign_second}"

#添加自动赋权
echo "UPDATE tvbox.tv_meals SET mealname='默认套餐', listinfo='${default_assign_all}' WHERE id=1;" >> IPTV_update.sql;

rm -f IPTV_update.sqltmp;
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
    response=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 "$api_url")

    if [[ $response -ge 200 && $response -lt 400 ]]; then
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



