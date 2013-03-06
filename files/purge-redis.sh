redis-cli info | grep human

/sbin/service celeryd stop
/sbin/service celerybeat stop
/sbin/service celeryev stop

echo 'flushall' | /usr/bin/redis-cli
/sbin/service redis restart
ps aux | egrep 'redis|PID' | grep -v grep
sleep 5

/sbin/service celeryd start
sleep 5
/sbin/service celerybeat start
/sbin/service celeryev start

redis-cli info | grep human

