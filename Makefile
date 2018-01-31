.PHONY: all init bash upgrade dist-upgrade dev-assets latest

include ./Makefile.base

all:    ##@development shorthand for 'build init up setup open'
all: init build up setup open

init:   ##@development initialize development environment
	cp -n .env-dist .env &2>/dev/null
	cp -n tests/.env-dist tests/.env &2>/dev/null
	cp -n project/config/local.env-dist project/config/local.env
	$(DOCKER_COMPOSE) run --rm php composer install
	mkdir -p web/assets runtime

bash:	 ##@development open application development bash
	$(DOCKER_COMPOSE) run --rm php bash

upgrade: ##@development update application packages
	$(DOCKER_COMPOSE) run --rm php composer update -v

dist-upgrade: ##@development update application packages after base-image update, rebuild
	$(DOCKER_COMPOSE) build --pull
	$(DOCKER_COMPOSE) run --rm php composer update -v
	$(DOCKER_COMPOSE) build --pull

dev-assets:	 ##@development open application development bash
	$(DOCKER_COMPOSE) run --rm -e APP_ASSET_USE_BUNDLED=0 php yii asset/compress src/config/assets.php web/bundles/config.php

latest: ##@development push to latest/release branch
	git push origin master:latest

