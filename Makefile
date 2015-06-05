build: web deploynaut

push: push-web push-deploynaut

deploynaut:
	docker build -f Dockerfile.deploynaut -t sminnee/deploynaut-test-server .

web:
	docker build -f Dockerfile.web -t sminnee/deploynaut-test-webserver .

push-web:
	docker push sminnee/deploynaut-test-webserver

push-deploynaut:
	docker push sminnee/deploynaut-test-server