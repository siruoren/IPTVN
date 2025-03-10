
import urllib.request
import json
import sys

def main(url):

    response = urllib.request.urlopen(url)
    data = json.load(response)
    for list in data['urls']:
        print(list['name']+ ' ' + list['url'])


item=sys.argv[1]
main(item)