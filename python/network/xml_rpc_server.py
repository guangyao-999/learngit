#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   xml_rpc_server.py
@Time    :   2020/01/03 11:04:49
@Author  :   sgy
@Contact :   suguangyao@ruijie.com.cn
@License :   (C)Copyright 2018-2019, RCD_OS
'''

from xmlrpc.server import SimpleXMLRPCServer

class KeyValueServer:
    """ RPC server
    
    Attributes:
    
    To use:
    """
    
    _rpc_methods_ = ['get', 'set', 'delete', 'exists', 'keys']

    def __init__(self, address):
        self._data = {}
        self.server = SimpleXMLRPCServer(address, allow_none=True)

        for name in self._rpc_methods_:
            self.server.register_function(getattr(self, name))

    def get(self, name):
        return self._data[name]

    def set(self, name, value):
        self._data[name] = value
    
    def delete(self, name):
        del self._data[name]
    
    def exists(self, name):
        return name in self._data

    def keys(self):
        return self._data.keys()

    def serve_forever(self):
        self.server.serve_forever()


if __name__ == "__main__":
    kvserv = KeyValueServer(('', 15000))
    kvserv.serve_forever()
