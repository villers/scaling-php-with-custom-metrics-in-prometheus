generate-in-docker:
	docker run --rm -v $(CURDIR):$(CURDIR) --workdir $(CURDIR) quay.io/coreos/jsonnet-ci jb update
	docker run --rm -v $(CURDIR):$(CURDIR) --workdir $(CURDIR) quay.io/coreos/jsonnet-ci ./build.sh index.jsonnet

install:
	kubectl apply -f manifests/setup
	kubectl apply -f manifests/
