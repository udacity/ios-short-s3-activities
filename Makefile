# variables
SERVER_NAME=activities-server

# targets
hello_s3: hello_swift hello_kitura
	@echo "what are you building?"
	@echo "a microservice?"

hello_swift:
	@echo "hello swift"

hello_kitura:
	@echo "hello kitura"

web_dev: build_web_image
	docker run --name ${SERVER_NAME} \
	-it --rm -v ${PWD}:/src \
	-w /src \
	-p 80:8080 kitura-server /bin/bash

build_web_image:
	docker build -t kitura-server -f Dockerfile-web .
