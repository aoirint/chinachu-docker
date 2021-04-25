ROOT_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: build
build:
	docker build -t aoirint/chinachu .

.PHONY: run
run: build
	docker run --rm -itd \
			-p "20772:20772" \
			-v "${ROOT_DIR}/recorded:/usr/local/chinachu/recorded" \
			-v "${ROOT_DIR}/log:/usr/local/chinachu/log" \
			-v "${ROOT_DIR}/data:/usr/local/chinachu/data" \
			-v "${ROOT_DIR}/config.json:/usr/local/chinachu/config.json" \
			-v "${ROOT_DIR}/rules.json:/usr/local/chinachu/rules.json" \
			aoirint/chinachu
