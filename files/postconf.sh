/usr/share/kermit-webui/setup.sh
/usr/share/kermit-webui/selinux/applyse.sh
/usr/local/bin/kermit/restmco/misc/applyse.sh

/sbin/service celeryd stop
/sbin/service celerybeat stop
/sbin/service celeryev stop

/sbin/service celeryd start
sleep 5
/sbin/service celerybeat start
/sbin/service celeryev start

/sbin/service httpd restart
