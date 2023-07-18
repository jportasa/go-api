export GO111MODULE=on

GOCMD=go
BINARY_NAME=api
TAG=0.0.4

binary:
	env GOOS=linux GOARCH=amd64 $(GOCMD) build -ldflags="-s -w" -o $(BINARY_NAME) -v

build:
	docker buildx build --platform=linux/amd64 . -t api:$(TAG)
	kind load docker-image --name prima-cluster api:$(TAG)

upgrade:
	$(GOCMD) get -u