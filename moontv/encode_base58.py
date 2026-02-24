import json
import base58

# 读取JSON文件
with open('config.txt', 'r', encoding='utf-8') as f:
    data = json.load(f)

# 将JSON对象转换为字符串
json_str = json.dumps(data, ensure_ascii=False, indent=2)

# 将字符串编码为bytes
json_bytes = json_str.encode('utf-8')

# 进行base58编码
base58_encoded = base58.b58encode(json_bytes)

# 将编码结果转换为字符串
base58_str = base58_encoded.decode('utf-8')

# 保存编码后的内容到新文件
with open('config_base58.txt', 'w', encoding='utf-8') as f:
    f.write(base58_str)

print("base58编码完成！")
print(f"原始文件大小: {len(json_bytes)} 字节")
print(f"编码后文件大小: {len(base58_str)} 字节")
print("编码结果已保存到 config_base58.txt")

# 显示部分编码结果（前100个字符）
print("\n编码结果预览（前100个字符）:")
print(base58_str[:100] + "...")
