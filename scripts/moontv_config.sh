#!/bin/bash
 cd "$(dirname "$0")"
 cd ../moontv;
# 一键更新配置脚本
echo "=== 开始更新配置 ==="

# 检查是否在正确的目录
if [ ! -f "api_list.txt" ]; then
    echo "错误：api_list.txt 文件不存在"
    echo "请在包含 api_list.txt 的目录中运行此脚本"
    exit 1
 fi

# 检查并安装依赖
echo "检查依赖..."

# 检查python是否安装
if ! command -v python3 &> /dev/null; then
    echo "错误：Python 3 未安装"
    exit 1
fi

# 检查pip是否安装
if ! command -v pip3 &> /dev/null; then
    echo "错误：pip3 未安装"
    exit 1
fi

# 安装必要的包
echo "安装必要的Python包..."
pip3 install --quiet requests base58

if [ $? -ne 0 ]; then
    echo "警告：依赖安装失败，尝试使用系统包..."
fi

# 运行更新脚本
echo "运行更新脚本..."
python3 update_config.py

# 检查执行结果
if [ $? -eq 0 ]; then
    echo "\n=== 更新完成！ ==="
    echo "结果文件："
    echo "- config_src.json: 原始合并去重数据"
    echo "- config.txt: base58编码后的数据"
else
    echo "\n=== 更新失败！ ==="
    exit 1
fi
