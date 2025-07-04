# -*- coding:utf-8 -*-
try:
    from dingtalkchatbot.chatbot import DingtalkChatbot
except ImportError:
    def DingtalkChatbot(webhook, secret):
        return zyRobot()

class zyRobot(object):
    def __init__(self):
        pass
        # '2018-09-28 22:45:50'
         
    def send_text(self,msg='',is_at_all=True):
        print(msg)
 
    def send_link(self,title='', text='', message_url=''):
        print(message_url)


