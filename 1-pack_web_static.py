#!/usr/bin/python3
"""
Fabric script that generates a .tgz archive from the contents
of the web_static folder of your AirBnB Clone repo,
using the function do_pack.
"""

from fabric.api import local
from datetime import datetime
import os


def do_pack():
    """Packs the content of web_static into a tgz archive"""
    try:
        time = datetime.now()
        time_str = time.strftime("%Y%m%d%H%M%S")
        filename = "versions/web_static_" + time_str + ".tgz"
        if os.path.isdir('versions') is False:
            local('mkdir -p versions/')
        local('tar -cvzf {} web_static'.format(filename))
        return filename
    except Exception:
        return None
