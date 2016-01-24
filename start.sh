#!/bin/bash

# If some env defaults are passed in, create this user
if [ -n "$DEFAULT_USER" -a -n "$DEFAULT_PASS" ]; then
    (echo $DEFAULT_PASS; echo $DEFAULT_PASS) | pure-pw useradd $DEFAULT_USER -u ftpuser -d /home/ftpusers/$DEFAULT_USER
    pure-pw mkdb
fi

exec /usr/sbin/pure-ftpd -c 30 -C 1 -l puredb:/etc/pure-ftpd/pureftpd.pdb -x -E -j -R