#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   json_rpc_server.py
@Time    :   2020/01/03 11:22:57
@Author  :   sgy
@Contact :   suguangyao@ruijie.com.cn
@License :   (C)Copyright 2018-2019, RCD_OS
'''

import json
from multiprocessing.connection import Listener
from threading import Thread

class RCPHandler():
    """RPC handler for json
    
    Attributes:
    
    To use:
    """
    
    def __init__(self):
        self._functions = {}

    def register_function(self, func):
        self._functions[func.__name__] = func

    def handle_connection(self, connection):
        try:
            func_name, args, kwargs = json.loads(connection.recv())
            try:
                r = self._functions[func_name](*args, **kwargs)
                connection.send(json.dumps(r))
            except Exception as ex:
                connection.send(json.dumps(str(ex)))
            
        except EOFError as ex:
            pass

def rpc_server(handler, address, authkey):
    """
    param :
    return:
    msg : 处理rpc请求，但是一次只能处理一个请求，只在本地使用，不在防火墙之外使用，以及需要添加认证使用
    """
    
    sock = Listener(address, authkey=authkey)
    while True:
        client = sock.accept()
        t = Thread(target=handler.handle_connection, args=(client,))
        t.daemon = True
        t.start()

def add(x, y):
    return x + y

handler = RCPHandler()
handler.register_function(add)
rpc_server(handler, ('localhost', 17000), authkey=b'peekaboo')