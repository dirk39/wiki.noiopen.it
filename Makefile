run:
	docker-compose up

build:
	docker-compose build --build-arg CURRENT_UID=$(shell id -u)

dev: build run

in:
	docker exec -ti wiki bash

restore:
	cp -v backup/* data/

backup:
	./backup.sh

setup:
	id -u | grep 0
	crontab $(shell pwd)/crontab
	cp wiki.service /etc/systemd/system
	systemctl enable wiki.service
	systemctl start wiki.service
	systemctl stop caddy
	cp Caddyfile /etc/caddy/Caddyfile
	systemctl start caddy
	systemctl enable caddy

.PHONY: all run build in backup restore setup dev

