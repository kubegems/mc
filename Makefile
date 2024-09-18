BIN_DIR?=bin
TAG?=registry.cn-beijing.aliyuncs.com/kubegems/mc:main

define go-build
	@echo "Building ${1}/${2}"
	@GOOS=${1} GOARCH=$(2) go build -gcflags=all="-N -l"  -o ${BIN_DIR}/mc-$(1)-$(2)
endef
##@ Build
build: ## Build local binary.
	- mkdir -p ${BIN_DIR}
	$(call go-build,linux,amd64)
	$(call go-build,linux,arm64)

docker: build
	@docker buildx build --platform linux/amd64,linux/arm64  --push -t $(TAG)  -f Dockerfile.dev ${BIN_DIR}

