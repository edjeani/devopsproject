IMAGE=secure-app
VERSION=0.1.0
OWNER?=$(shell git config --get remote.origin.url | sed -E 's#.*github.com[:/](.*)/.*#\1#')
REG=ghcr.io

build:
	docker build -t $(IMAGE):$(VERSION) .

run:
	docker run --rm -p 3000:3000 $(IMAGE):$(VERSION)

scan:
	trivy image --severity HIGH,CRITICAL $(IMAGE):$(VERSION)

sbom:
	syft packages docker:$(IMAGE):$(VERSION) -o json > sbom.json

push:
	docker tag $(IMAGE):$(VERSION) $(REG)/$(OWNER)/$(IMAGE):$(VERSION)
	echo $$GITHUB_TOKEN | docker login $(REG) -u $$GITHUB_ACTOR --password-stdin
	docker push $(REG)/$(OWNER)/$(IMAGE):$(VERSION)

sign:
	COSIGN_EXPERIMENTAL=1 cosign sign -y $(REG)/$(OWNER)/$(IMAGE):$(VERSION)
