#!/usr/bin/env bash

# Return IP(s) from the VM
echo -e '================================='
ip addr | grep 'state UP' -A2 | grep 'inet ' | tail -n +2 | awk '{print "IP:\t\t"$2}'
echo -e "Frontend:\t\thttp://`hostname -f`"
echo -e "MySQL:\t\thttp://`hostname -f`/phpMyAdmin"
echo -e "Web mail:\t\thttp://`hostname -f`/webmail"
echo -e "Caching:\t\thttp://`hostname -f`/OpCacheGUI"
echo -e "PHP-FPM:\t\thttp://`hostname -f`/server-(status|ping)"
echo -e '================================='