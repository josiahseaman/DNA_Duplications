#!/usr/bin/env python

from __future__ import print_function

import os
import sys

from read_trimming import call, remove_extensions, just_the_name

server_cmd_path = "/usr/local/bin/clcserver"
parse_cmd_path = "/usr/local/bin/clcresultparser"
password_token = 'BAAAAAAAAAAAAAP5d9b3a807f99338e--260f6b54-15d0dbc6aad--8000'
server_cmd = server_cmd_path + ' -S atta1.ad.kew.org -P 7777 -U jseaman -W %s ' % password_token

"""

"""