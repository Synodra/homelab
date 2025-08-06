ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

##@ Homelab 🐳

.PHONY: update
update: ## Update the service(s) *
	docker compose --project-directory "$(ROOT_DIR)" --profile all pull $(APP)
	docker compose --project-directory "$(ROOT_DIR)" --profile all up -d $(APP)
# 	docker image prune -af

.PHONY: pull
pull: ## Pull the latest image(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile all pull $(APP)

.PHONY: up
up: ## Start the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile all up -d $(APP) $(ARGS)

.PHONY: down
down: ## Stop the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile all down $(APP) $(ARGS)

.PHONY: stop
stop: ## Stop the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile all stop $(APP) $(ARGS)

.PHONY: logs
logs: ## Show the logs*
	docker compose --project-directory "$(ROOT_DIR)" --profile all logs $(APP) -ft $(ARGS)

.PHONY: restart
restart: ## Restart the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile all restart  $(APP) $(ARGS)

##@ Configuration 🪛

.PHONY: config-acme
config-acme: ## Initialize the acme.json file.
	mkdir -p appdata/traefik/acme/
	rm -f appdata/traefik/acme/acme.json
	touch appdata/traefik/acme/acme.json
	chmod 600 appdata/traefik/acme/acme.json

.PHONY: config-cert
config-cert: ## Initialize the *.home.lan cert.
	mkdir -p appdata/traefik/certs
	rm -f appdata/traefik/certs/local.crt appdata/traefik/certs/local.key
	mkcert -cert-file appdata/traefik/certs/local.crt -key-file appdata/traefik/certs/local.key "home.lan" "*.home.lan"

##@ General 🌐

.PHONY: version
version: ## Show the version of the project.
	@git fetch --unshallow 2>/dev/null || true
	@git fetch --tags 2>/dev/null || true
	@echo "homelab $$(git describe --tags --abbrev=0)"

################################################
# Auto-Generated Help:
# - "##@" denotes a target category
# - "##" denotes a specific target description
###############################################
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help message and exit
	@printf "\033[1;34mUsage:\033[0m \033[1;32mhomelab\033[0m \033[1;33m[target]\033[0m \033[1;36m(APP=service-name)\033[0m\n"
	@echo ""
	@printf "* pass \033[1;36mAPP=service-name\033[0m to specify the service\n"
	@printf "* pass \033[1;36mARGS=arguments\033[0m to specify additional arguments\n"
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-19s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)