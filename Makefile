.PHONY: help

help:
	@echo "\033[32mmake up \033[0m- up containers"
	@echo "\033[32mmake php \033[0m- go into php container"
	@echo "\033[32mmake db \033[0m- go into influx container"
	@echo "\033[32mmake telegraf \033[0m- go into telegraf container"
	@echo "\033[32mmake grafana \033[0m- go into grafana container"
	@echo "\033[32mmake logs \033[0m- show logs"

up:
	CURRENT_UID=$(id -u):$(id -g) docker-compose up

down:
	docker-compose down

wipe:
	docker-compose down -v

php:
	@echo "\033[32mEntering into php container...\033[0m"
	docker-compose exec php bash

php-run:
	@echo "\033[32mRun the PHP Example...\033[0m"
	docker-compose exec php php /var/www/html/example.php

db:
	@echo "\033[32mEntering into influx container...\033[0m"
	docker-compose exec influxdb bash

telegraf:
	@echo "\033[32mEntering into telegraf container...\033[0m"
	docker-compose exec telegraf bash

grafana:
	@echo "\033[32mEntering into grafana container...\033[0m"
	docker-compose exec grafana bash

influx-cli:
	@echo "\033[32mRun the influx client...\033[0m"
	docker-compose exec influxdb influx -execute 'SHOW DATABASES'

influx-console:
	@echo "\033[32mRun the influx interactive console...\033[0m"
	docker-compose exec influxdb influx

influx-import:
	@echo "\033[32mImport data from a file...\033[0m"
	docker-compose exec -w /imports influxdb influx -import -path=data.txt -precision=s

logs:
	docker-compose logs -f
