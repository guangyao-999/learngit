#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   xml_rpc_clinet.py
@Time    :   2020/01/03 11:14:22
@Author  :   sgy
@Contact :   suguangyao@ruijie.com.cn
@License :   (C)Copyright 2018-2019, RCD_OS
'''

from xmlrpc.client import ServerProxy

s = ServerProxy('http://localhost:15000', allow_none=True)

s.set('foo', 'test')
print(s.get('foo'))