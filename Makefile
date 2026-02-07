.PHONY: build run run-no-firewall shell clean

build:
	docker compose build

run: build
	docker compose run --rm claude

run-no-firewall: build
	docker compose run --rm -e ENABLE_FIREWALL=false claude

shell: build
	docker compose run --rm --entrypoint bash claude

clean:
	docker compose down --rmi all --volumes
