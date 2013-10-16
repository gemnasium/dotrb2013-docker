user=fcat
project=dotrb2013

# cache images
ubuntu_universe=${user}/ubuntu-universe
ubuntu_universe_tagged=${ubuntu_universe}:12.04
rails_base=${user}/${project}-rails-base

# final images
postgresql=${user}/postgresql
rails=${user}/${project}-rails

all:

build:
	docker build -t ${ubuntu_universe_tagged} ubuntu-universe
	docker build -t ${rails_base} rails-base
	docker build -t ${rails} rails
	docker build -t ${postgresql} postgresql

list:
	docker images ${ubuntu_universe}
	docker images ${rails_base}
	docker images ${rails}
	docker images ${postgresql}

pull:
	docker pull ${rails}
	docker pull ${postgresql}

push:
	docker push ${ubuntu_universe}
	docker push ${rails_base}
	docker push ${rails}
	docker push ${postgresql}

run:
	docker run ${rails}
	docker run ${postgresql}

ps:
	docker ps 
