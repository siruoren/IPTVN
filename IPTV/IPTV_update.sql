set character_set_server='utf8';
UPDATE tvbox.tv_app SET appkey = 'bef838a270105a93935038c844192fd3' WHERE name = '群晖影视';
TRUNCATE table tvbox.tv_channels;
INSERT into tvbox.tv_channels(name,category,url) values('default', 'default', 'default');
SELECT SLEEP(5);
DELETE FROM tvbox.tv_channels where name='default';
UPDATE tvbox.tv_meals SET mealname='默认套餐', listinfo='央视频道,卫视频道,电影频道,经典剧场,动画频道,音乐频道,体育频道,游戏频道,港澳台,山东频道,北京频道,吉林频道,上海频道,云南频道,四川频道,天津频道,宁夏频道,安徽频道,山西频道,广东频道,广西频道,新疆频道,江苏频道,河北频道,河南频道,浙江频道,湖北频道,湖南频道,甘肃频道,福建频道,贵州频道,辽宁频道,重庆频道,陕西频道,青海频道,黑龙江频道,内蒙频道' WHERE id=1;
