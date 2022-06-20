OPENCV_VERSION := $(shell grep OPENCV_VERSION .version | cut -d '=' -f '2')
GOLANG_VERSION := $(shell grep GOLANG_VERSION .version | cut -d '=' -f 2)
PLATFORM := linux/amd64,linux/arm64

opencv.base-amd64:
	docker buildx build --push --platform=linux/amd64	\
		--file=opencv.Dockerfile \
		--tag=khlipeng/opencv-debian:$(OPENCV_VERSION)-amd64	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.

opencv.base-arm64:
	docker buildx build --push --platform=linux/arm64	\
		--file=opencv.Dockerfile \
		--tag=khlipeng/opencv-debian:$(OPENCV_VERSION)-arm64	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.

go:
	docker buildx build --push --progress plain \
		--platform=$(PLATFORM) \
		--file=go.Dockerfile \
		--tag=khlipeng/go-debian:$(OPENCV_VERSION)-$(GOLANG_VERSION) \
		--build-arg=GOLANG_VERSION=$(GOLANG_VERSION)	\
		--build-arg=OPENCV_VERSION=$(OPENCV_VERSION)	\
		.
