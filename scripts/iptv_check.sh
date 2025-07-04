cd $(dirname $0);
cd ../IPTV-M3U-Checker2;
pip3 install --user -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple;
python3 main.py
