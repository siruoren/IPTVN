
import urllib.request
import json
import sys

def main(url,type):
    response = urllib.request.urlopen(url)
    data = json.load(response)
    if type == 'sum':
        duochang_file= open('duochang.json','a+w')
        sum_data = json.load(duochang_file)
        for list in data['urls']:
            sum_data['urls'].append(list)
        duochang_file.close()
    else if type == 'add':
        for list in data['urls']:
            print(list['name']+ ' ' + list['url'])


item=sys.argv[1]
type=sys.argv[2]
main(item,type)