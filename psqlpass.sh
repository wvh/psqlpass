#!/bin/sh
#
# -wvh- script based on oneliner to create a MD5 hashed password for postgresql
#
#       oneliner:
#
#         $ env DBUSER=app DBPASS='secret' bash -c 'echo -n "${DBPASS}${DBUSER}"' | md5sum | cut -d' ' -f1
#         6a422f785c9e20873908ce25d1736ae2
#
#       Prepend "md5" and give as argument to CREATE USER/ROLE:
#
#         CREATE ROLE WITH ENCRYPTED PASSWORD 'md56a422f785c9e20873908ce25d1736ae2'
#

set -e

if [ -z "$1" ]; then
	echo usage: "$0 <username> [password]"
	exit 1
fi

DBUSER="$1"
DBPASS="$2"

if [ -z "$2" ]; then
	DBPASS=$(< /dev/urandom tr -dc 'A-Za-z0-9-_#@/+?!&,.${}()[]' | head -c16)
	echo "pass: ${DBPASS}"
	echo -n "hash: "
fi

echo -n md5
echo -n "${DBPASS}${DBUSER}" | md5sum | cut -d' ' -f1
