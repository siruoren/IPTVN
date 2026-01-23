#!/bin/bash

cd $(dirname $0);
default_assign_first="央视频道,卫视频道,数字频道,电影频道,经典剧场,动画频道,体育频道,游戏频道,影视轮播"
default_assign_second=",山东频道,北京频道,吉林频道,上海频道,云南频道,四川频道,天津频道,宁夏频道,安徽频道,山西频道,广东频道,广西频道,新疆频道,江苏频道,河北频道,河南频道,浙江频道,湖北频道,湖南频道,甘肃频道,福建频道,贵州频道,辽宁频道,重庆频道,陕西频道,青海频道,海南频道,黑龙江频道,内蒙频道,内蒙古频道,港澳台"

exclude_pd="湖南移动,YY轮播,哔哩轮播,斗鱼轮播,卫视备用,卫视高清,虎牙轮播,音乐频道,其他频道,地方频道,解说频道,春晚频道,体验频道,央视付费频道,咪咕直播,更新时间,成人频道"

# 源
> ../IPTV.m3u
mkdir -p ../IPTV;


rm -rf ../IPTV/*.m3u;

while read extend_line|| [ ! -n $extend_line ]
do
if [ "${extend_line}" != '' ];then
    echo ${extend_line}
    src_name=`echo $extend_line|awk '{print$1}'`
    src_url=`echo $extend_line|awk '{print$2}'`
    wget ${src_url} -O ${src_name}.m3u;
    extend_group_name='未分类'
    while read line|| [ ! -n $line ]
    do
            if [[ ${line} =~ '#genre#' ]];then
                            extend_group_name=`echo ${line}|grep '#genre#'|awk -F',' '{print$1}'`
                            continue
            fi

            if [[ ${extend_group_name} != '' || ${line} =~ 'http' ]];then
                channel_name=`echo ${line}|awk -F',' '{print$1}'`
                if [[ $extend_group_name == '未分类' ]];then
                    extend_group_name=`cat ../IPTV.m3u|grep "${channel_name}"|awk -F'group-title=' '{print$2}'|awk -F',' '{print$1}'|head -1||echo '未分类'`
                    echo "extend_group_name: ${extend_group_name} !!!!"
                fi


                urls=`echo ${line}|awk -F',' '{print$2}'`
                for url in `echo $urls|awk -F '#' '{for(i=1;i<=NF;i++) print$i}'`
                do
                if [[ ${url} =~ 'http' ]];then
                    echo "#EXTINF:-1 tvg-name=\"$channel_name\" group-title=\"${extend_group_name}\",$channel_name" >> ../IPTV.m3u
                    echo ${url}|sed 's/$.*//g' >> ../IPTV.m3u
                fi
                done
            fi

    done < ${src_name}.m3u
    rm -f ${src_name}.m3u;
fi
done < ../IPTV/iptv_src_extend.list;



while read line|| [ ! -n $line ]
do

src_name=`echo $line|awk '{print$1}'`
src_url=`echo $line|awk '{print$2}'`
wget ${src_url} -O ${src_name}.m3u;cat ${src_name}.m3u|sed 's/$.*//g' >> ../IPTV.m3u;rm -f ${src_name}.m3u;


done < ../IPTV/iptv_src.list;

# 去重
cp ../IPTV.m3u  ../IPTV.m3utmp;>../IPTV.m3u;
cat ../IPTV.m3utmp |grep '^http'|while read url
do 
    if [ `cat ../IPTV.m3u|grep "${url}"|wc -l ` = 0 ];then 
        channel_info=`cat ../IPTV.m3utmp|grep -B 1 "${url}"|head -2`  
        group_name=`echo ${channel_info}|grep 'group-title'|awk '{for(i=1;i<=NF;i++) print $i}'|grep 'group-title'|sed 's/,.*//g'|sed 's/"//g'|awk -F'=' '{print$2}'|sed 's/[^[:alpha:]]//g'`
        # echo ${group_name}
        if [[ "${exclude_pd}" =~ "${group_name}" ]];then
            # echo "${channel_info}"
            if [[ "${group_name}" != ""  ]];then
                echo "${group_name} is in exclude_pd !!!!"
            fi
            continue
        else
        
            echo "${channel_info}" >> ../IPTV.m3u
        fi
    fi; 
done
rm -f ../IPTV.m3utmp;




cd ../IPTV
#cat ../IPTV.m3u |grep 'group-title'|awk -F ',' '{print$1}'|awk '{print$NF}'|grep "^group"|sort|uniq|awk -F'"' '{print$2}'|xargs -i touch {}.m3u
 cat ../IPTV.m3u |awk '{for(i=1;i<=NF;i++) print $i}'|grep 'group-title'|sed 's/,.*//g'|sed 's/"//g'|awk -F'=' '{print$2}'|sort|uniq|xargs -i touch {}.m3u



for i in `ls *.m3u`; do group_name=`echo ${i}|awk -F '.' '{print$1}'`; grep -A 1 "${group_name}" ../IPTV.m3u > ${i}; done
ls -l
dos2unix *.m3u;
cd ../


#iptv_to_sql and txt




cd IPTV;
> IPTV_update.sqltmp;
> zbtv.txttmp;
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
      default_assign_second=`echo ${default_assign_second},${group_name}`
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
                    if [[ "${item_id}" == '' ]];then
                        item_id=`sed -n "${line_nu}p" ${m3u_file}|awk -F',' '{print$NF}'|sed 's/"//g'|xargs echo -n`
                    fi
    			    item_group=`sed -n "${line_nu}p" ${m3u_file}|awk -F'group-title=' '{print$2}'|awk '{printf$1}' |sed 's/"//g'|awk -F',' '{printf$1}'|sed 's/[^[:alpha:]]//g'|xargs echo -n `
                    if [[ `echo ${item_group}|grep -iE "Movies|電影"|wc -l`  -ne 0  ]];then
                        item_group='电影频道'
                    elif [[ `echo ${item_group}|grep -iE "总台|央视"|wc -l`  -ne 0  ]];then
                        item_group='央视频道'
                    fi
    			    item_url=`sed -n "${line_next}p" ${m3u_file}|grep '^http'|xargs echo -n`
                    url_res='skip'
                    # if [[ "${default_assign_first}" =~ "${item_group}" ]];then
                    #     if [[ "${item_url}" =~ '\[' ]];then
                    #         url_res=`curl -6 -o /dev/null -s -w "%{http_code}" --max-time 3 "${item_url}"`
                    #         #url_res='skip'
                    #     else
                    #         url_res=`curl -o /dev/null -s -w "%{http_code}" --max-time 3 "${item_url}"`
                    #     fi
                    # else
                    #     url_res='skip'

                    # fi
                    if [[ "${url_res}" -eq "200" ]];then
                        #echo "${item_id}: ${item_url} is ok......"
                        echo "INSERT into tvbox.tv_channels(name,category,url) select '${item_id}','${item_group}','${item_url}' where NOT EXISTS (SELECT 1 FROM tvbox.tv_channels WHERE url='${item_url}');" >> IPTV_update.sqltmp
                        echo "${item_group},${item_id},${item_url}" >> zbtv.txttmp;
                    elif [[ "${url_res}" -eq "skip" ]];then
                        #echo "${item_id}: ${item_url} is skip testing......"
                        echo "INSERT into tvbox.tv_channels(name,category,url) select '${item_id}','${item_group}','${item_url}' where NOT EXISTS (SELECT 1 FROM tvbox.tv_channels WHERE url='${item_url}');" >> IPTV_update.sqltmp
                        echo "${item_group},${item_id},${item_url}" >> zbtv.txttmp;

                    else
                        echo "${item_id}: ${item_url} is unaccessible,ignore update"
                    fi
                    #echo $i
    			    i=` expr $i + 1 `
    	    fi
    	fi

     fi
    done

done

> zbtv.txt


for group_name in `echo $default_assign_first|awk -F ',' '{for(i=1;i<=NF;i++) print$i}'`
do
    if [[ `cat zbtv.txttmp|grep "^${group_name}"|wc -l` != "0" ]]; then
        echo "${group_name},#genre#" >> zbtv.txt;
        cat zbtv.txttmp|grep "^${group_name}"|awk -F ',' '{print$2","$3}' >> zbtv.txt;
    fi

done

for group_name in `echo $default_assign_second|awk -F ',' '{for(i=1;i<=NF;i++) print$i}'`
do
    if [[ "${group_name}" == "" ]]; then
        continue
    fi
    if [[ `cat zbtv.txttmp|grep "^${group_name}"|wc -l` != "0" ]]; then
        echo "${group_name},#genre#" >> zbtv.txt;
        cat zbtv.txttmp|grep "^${group_name}"|awk -F ',' '{print$2","$3}' >> zbtv.txt;
    fi

done



rm -f zbtv.txttmp;



> IPTV_update.sql;
echo "set character_set_server='utf8';" >> IPTV_update.sql;
echo "UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';" >> IPTV_update.sql;
echo "TRUNCATE table tvbox.tv_channels;" >> IPTV_update.sql;
echo "INSERT into tvbox.tv_channels(name,category,url) values('default', 'default', 'default');" >> IPTV_update.sql;
echo "SELECT SLEEP(5);" >> IPTV_update.sql;
cat IPTV_update.sqltmp|grep -iE "总台|央视"|grep -v '\\'|grep -v liveshow >> IPTV_update.sql;
cat IPTV_update.sqltmp|grep -ivE "总台|央视"|grep -v '\\' >> IPTV_update.sql;
echo "DELETE FROM tvbox.tv_channels where name='default';" >> IPTV_update.sql;
default_assign_all="${default_assign_first}${default_assign_second}"

#添加自动赋权
echo "ALTER TABLE tvbox.tv_meals MODIFY COLUMN listinfo varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '默认分类' NOT NULL;" >> IPTV_update.sql;
echo "UPDATE tvbox.tv_meals SET mealname='默认套餐', listinfo='${default_assign_all}' WHERE id=1;" >> IPTV_update.sql;

rm -f *.m3u *.sqltmp;
cd ../;
