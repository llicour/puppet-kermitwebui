# PostgreSQL :
su - postgres -c 'psql kermit -c "delete from restserver_backendjob;"'

# SQLite :
sqlite3 -line /var/lib/kermit/webui/db/sqlite.db 'delete from restserver_backendjob;'
