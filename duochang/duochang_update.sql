set character_set_server='utf8';
UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '高天','https://wget.la/raw.githubusercontent.com/gaotianliuyun/gao/master/js.json','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '高天');
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '香雅情','https://wget.la/https://raw.githubusercontent.com/xyq254245/xyqonlinerule/main/XYQTVBox.json','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '香雅情');
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select 'qist_tvbox','https://wget.la/raw.githubusercontent.com/qist/tvbox/master/jsm.json','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = 'qist_tvbox');
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '讴歌','http://tv.nxog.top/m','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '讴歌');
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select 'OK影视','https://jsdelivr.pai233.top/gh/2hacc/TVBox@main/oktv.json','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = 'OK影视');
INSERT into tvbox.tv_app_duocang(name, url, appid, status, status_dcjm) select '刘备','https://raw.liucn.cc/box/m.json','10000','y','n' where NOT EXISTS (SELECT 1 FROM tvbox.tv_app_duocang WHERE name = '刘备');
