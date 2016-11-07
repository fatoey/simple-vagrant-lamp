if [ -f /var/sqldump/delphic_wp.sql ];
then
    DATE=$(date +"%Y%m%d%H%M")

    #mysql -uroot -proot delphic_wp < /var/sqldump/delphic_wp.sql
	mysql -uroot -proot delphic_wp < /var/sqldump/delphic_wp-migrate-20160120145600.sql
    # mv /var/sqldump/database.sql /var/sqldump/$DATE-imported.sql
fi
