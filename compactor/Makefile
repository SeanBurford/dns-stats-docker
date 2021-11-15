default: help

IMAGES_REPO ?= seanburford
IMAGE_NAME ?= dns-stats-compactor
IMAGE_TAG ?= 1.2.0
NO_CACHE :=

.PHONY: no-cache
no-cache:
	$(eval NO_CACHE := --no-cache)
	@:

.PHONY: image
image:
	docker build $(NO_CACHE) --rm=true --force-rm=true --tag=$(IMAGE_NAME):$(IMAGE_TAG) .

.PHONY: build
build: image

.PHONY: rebuild
rebuild: no-cache image

.PHONY: push
push:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGES_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(IMAGES_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: all
all: build push

.PHONY: help
help:
	@echo "Build the $(IMAGE_NAME) image"
	@echo
	@echo "Usage: make TARGETS VARS"
	@echo
	@echo "The following TARGETS are supported"
	@echo
	@echo "image: build the docker image locally"
	@echo "no-cache: disable docker layer caching"
	@echo "build: runs image"
	@echo "rebuild: runs no-cache + image"
	@echo "push: push the image to a repo"
	@echo "all: runs build + push"
	@echo "help: display this help"
	@echo
	@echo "The following VARS are supported"
	@echo
	@echo "IMAGES_REPO: repository name to push image to"
	@echo "IMAGE_NAME: override default image name"
	@echo "IMAGE_TAG: override default image tag"
