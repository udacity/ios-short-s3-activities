DOCKER_IMAGE='ibmcom/kitura-ubuntu'

build:
	swift build

run:
	./.build/debug/activities

test:
	swift test

test_docker:
	docker run -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash -c 'swift test --build-path=/.build'

build_docker:
	docker run -it --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash -c 'swift build --build-path=/.build'

docker_dev:
	docker run -it --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash
