
import urllib.request
import json
import sys

def main(url):
    try:
        response = urllib.request.urlopen(url)
        data = json.load(response)
        duochang_file= open('duochang.json','a+w')
        sum_data = json.load(duochang_file)
        for list in data['urls']:
            print(list['name']+ ' ' + list['url'])
            if list['name'] not in sum_data['urls']:
                sum_data['urls'].append(list)
        duochang_file.close()
    except Exception as e:
        print(e)

item=sys.argv[1]
main(item)