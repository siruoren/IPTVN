
import urllib.request
import json
import sys

def main(url):
    try:
        response = urllib.request.urlopen(url)
        data = json.load(response)
        sum_data = json.load(duochang_file)
        for list in data['urls']:
            print(list['name']+ ' ' + list['url'])
    except :
        continue

item=sys.argv[1]
main(item)