VERSION := $(shell cat VERSION)
IMAGE   := valshatravenko/hellonode:$(VERSION)

default: build run

build:
	@echo '> Building "hellonode" docker image...'
	@docker build -t $(IMAGE) .

run:
	@echo '> Starting "hellonode" container...'
	@docker run -d $(IMAGE)

ci:
	@fly -t ci set-pipeline -p hellonode -c config/pipelines/review.yml --load-vars-from config/pipelines/secrets.yml -n
	@fly -t ci unpause-pipeline -p hellonode

deploy:
	@helm install ./config/charts/hellonode --set "image.tag=$(VERSION)"
