
import urllib.request
import json
import sys

def main(url):

    response = urllib.request.urlopen(url,timeout=10.0)
    data = json.load(response)
    for list in data['urls']:
        print(list['name']+ ' ' + list['url'])


item=sys.argv[1]
main(item)