DOCKER_REPOSITORY=amirsamary/irisdemo

build:
	-docker-compose stop
	-docker-compose rm -f
	-docker-compose build

clean:
	-docker-compose rm -f
	-docker rmi ${DOCKER_REPOSITORY}:fhir_DB
	-docker rmi ${DOCKER_REPOSITORY}:iam.IAM-stable
	
run:
	-docker-compose up