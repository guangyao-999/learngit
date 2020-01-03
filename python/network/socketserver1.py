#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   sockerserver.py
@Time    :   2020/01/03 09:50:26
@Author  :   sgy
@Contact :   suguangyao@ruijie.com.cn
@License :   (C)Copyright 2018-2019
'''

from socketserver import BaseRequestHandler
from socketserver import TCPServer


class EchoHandler(BaseRequestHandler):
    def handle(self):
        print('Got connection from', self.client_address)
        while True:
            msg = self.request.recv(8192)
            if not msg:
                break
            
            self.request.send(msg)


if __name__ == '__main__':
    serv = TCPServer(('', 20000), EchoHandler)
    serv.serve_forever()
