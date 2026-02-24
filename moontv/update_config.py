import json
import requests
import base58
import os

def load_json_from_url(url):
    """从URL加载JSON数据"""
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"加载 {url} 失败: {e}")
        return None

def merge_and_deduplicate(json_list):
    """合并多个JSON对象并去重"""
    merged = {}
    
    # 合并所有JSON数据
    for data in json_list:
        if data:
            for key, value in data.items():
                if key not in merged:
                    merged[key] = value
                elif isinstance(merged[key], dict) and isinstance(value, dict):
                    # 如果是嵌套字典，递归合并
                    merged[key].update(value)
                elif isinstance(merged[key], list) and isinstance(value, list):
                    # 如果是列表，合并并去重
                    merged[key] = list(set(merged[key] + value))
    
    return merged

def main():
    print("开始更新配置...")
    
    # 读取API列表
    api_list = []
    with open('api_list.txt', 'r', encoding='utf-8') as f:
        for line in f:
            url = line.strip()
            if url:
                api_list.append(url)
    
    print(f"找到 {len(api_list)} 个API URL")
    
    # 加载所有JSON数据
    json_data_list = []
    for url in api_list:
        print(f"加载 {url}...")
        data = load_json_from_url(url)
        if data:
            json_data_list.append(data)
    
    if not json_data_list:
        print("没有成功加载任何JSON数据")
        return
    
    # 合并并去重
    print("合并并去重数据...")
    merged_data = merge_and_deduplicate(json_data_list)
    
    # 保存原始合并数据
    print("保存原始数据到 config_src.json...")
    with open('config_src.json', 'w', encoding='utf-8') as f:
        json.dump(merged_data, f, ensure_ascii=False, indent=2)
    
    # 转换为字符串并进行base58编码
    print("进行base58编码...")
    json_str = json.dumps(merged_data, ensure_ascii=False, indent=2)
    json_bytes = json_str.encode('utf-8')
    base58_encoded = base58.b58encode(json_bytes)
    base58_str = base58_encoded.decode('utf-8')
    
    # 保存编码后的数据
    print("保存编码后数据到 config.txt...")
    with open('config.txt', 'w', encoding='utf-8') as f:
        f.write(base58_str)
    
    print("\n更新完成！")
    print(f"原始数据大小: {len(json_bytes)} 字节")
    print(f"编码后数据大小: {len(base58_str)} 字节")
    print("结果文件:")
    print("- config_src.json: 原始合并去重数据")
    print("- config.txt: base58编码后的数据")

if __name__ == "__main__":
    main()
