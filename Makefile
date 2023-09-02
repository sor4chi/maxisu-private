.PHONY: rotate-all
rotate-all: rotate-access-log rotate-slow-log

.PHONY: rotate-access-log
rotate-access-log:
	echo "Rotating access log"
	sudo mv /var/log/nginx/access.ndjson /var/log/nginx/access.ndjson.$(shell date +%Y%m%d)
	sudo systemctl restart nginx

.PHONY: rotate-slow-log
rotate-slow-log:
	echo "Rotating slow log"
	sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.$(shell date +%Y%m%d)
	sudo systemctl restart mysql

.PHONY: alp
alp:
	alp json -c alp-config.yml
  
.PHONY: conf-deploy
conf-deploy: nginx-conf-deploy mysql-conf-deploy

.PHONY: nginx-conf-deploy
nginx-conf-deploy:
	echo "nginx Config Deploy"
	sudo cp ~/private_isu/webapp/etc/nginx/conf.d/isucon.conf /etc/nginx/sites-available/isucon.conf
	sudo nginx -t
	sudo systemctl restart nginx


.PHONY: mysql-conf-deploy
mysql-conf-deploy:
	echo "mysql Config Deploy"
	sudo cp ~/private_isu/webapp/etc/my.cnf /etc/mysql/my.cnf
	mysqld --verbose --help > /dev/null
	sudo systemctl restart mysql
