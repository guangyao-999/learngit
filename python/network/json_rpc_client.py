#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   json_rpc_client.py
@Time    :   2020/01/03 11:36:28
@Author  :   sgy
@Contact :   suguangyao@ruijie.com.cn
@License :   (C)Copyright 2018-2019, RCD_OS
'''

import json
from multiprocessing.connection import Client

class RPCProxy():
    """RPC client for json
    
    Attributes:
    
    To use:
    """
    def __init__(self, connection):
        self._connection = connection
    
    def __getattr__(self, name):
        def do_rpc(*args, **kwargs):
            self._connection.send(json.dumps((name, args, kwargs)))
            result = json.loads(self._connection.recv())
            return result

        return do_rpc
    
if __name__ == "__main__":
    c = Client(('localhost', 17000), authkey=b'peekaboo')
    proxy = RPCProxy(c)
    print(proxy.add(4, 3))