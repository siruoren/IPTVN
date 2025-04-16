
import urllib.request
import json
import sys

def main(url):
    with open('duochang.json','w',encoding='utf-8') as file:
        duochang_json=json.loads(duochang_data)
        response = urllib.request.urlopen(url,timeout=10.0)
        data = json.load(response)
        for list in data['urls']:
            duochang_json['storeHouse'].append(list)
            print(list['name']+ ' ' + list['url'])
        json.dump(duochang_json,file,ensure_ascii=False,indent=4)

item=sys.argv[1]
main(item)