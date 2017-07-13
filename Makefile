DOCKER_IMAGE='ibmcom/kitura-ubuntu'

build:
	swift build -Xlinker -L/usr/local/lib

clean:
	rm -rf .build

run:
	./.build/debug/activities

unit_test:
	swift test -s ActivitiesTests.HandlersTests -Xlinker -L/usr/local/lib
	swift test -s ActivitiesTests.QueryResultAdaptorTests -Xlinker -L/usr/local/lib

functional_test:
	swift test -s FunctionalTests.FunctionalTests -Xlinker -L/usr/local/lib

unit_test_docker:
	docker run --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash -c 'swift test -s ActivitiesTests.HandlersTests --build-path=/.build'

functional_test_docker:
	docker run --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash -c 'swift test -s FunctionalTests.FunctionalTests --build-path=/.build'

build_docker:
	docker run -it --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash -c 'swift build --build-path=/.build'

docker_dev:
	docker run -it --rm -v $(shell pwd):/src -w /src ${DOCKER_IMAGE} /bin/bash
