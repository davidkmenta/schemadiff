REGISTRY = registry.hub.docker.com/kmenta
REPOSITORY = schemadiff

IMAGE_VERSION = v1.0.0
SCHEMADIFF_VERSION = v1.4

IMAGE = $(REGISTRY)/$(REPOSITORY):$(IMAGE_VERSION)

all: build_and_publish

build_and_publish:
	docker buildx create --use --name multiarch-builder \
	&& docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--progress plain \
		--tag $(IMAGE) \
		--build-arg SCHEMADIFF_VERSION="$(SCHEMADIFF_VERSION)" \
		--no-cache \
		--push \
		. \
	&& make remove_builder

remove_builder:
	docker buildx rm multiarch-builder

.PHONY: all build_and_publish

