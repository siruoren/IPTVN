import json

# 读取原始文件内容
with open('config.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# 解析JSON
data = json.loads(content)

# 检查api_site部分
if 'api_site' in data:
    # 由于JSON解析时会自动去重（后面的覆盖前面的），
    # 我们需要重新构建整个结构，确保只保留唯一的键
    # 这里的操作实际上会保留最后出现的重复项
    unique_api_sites = {}
    
    # 为了确保去重效果，我们直接使用解析后的数据
    # 因为JSON解析器已经处理了重复键的问题
    unique_api_sites = data['api_site']
    
    # 更新回数据
    data['api_site'] = unique_api_sites
    
    # 写入去重后的数据
    with open('config.txt', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"去重完成！处理后API站点数量: {len(unique_api_sites)}")
    print("注意：JSON解析器会自动处理重复键，保留最后出现的项")
else:
    print("未找到api_site部分")
