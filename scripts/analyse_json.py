
import urllib.request
import json
import sys

def main(url):
    dc_file = open('duocang.json','r',encoding='utf-8')
    file_data=dc_file.read()
    duochang_json=json.loads(file_data)
    if 'storeHouse' not in duochang_json:
        duochang_json['storeHouse'] = []
    response = urllib.request.urlopen(url,timeout=10.0)
    data = json.load(response)
    for list in data['urls']:
        print(list['name']+ ' ' + list['url'])
        duochang_json['storeHouse'].append(list)
    with open('duocang.json','w',encoding='utf-8') as file:
        json.dump(duochang_json,file,ensure_ascii=False,indent=4)

item=sys.argv[1]
main(item)