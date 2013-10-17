user=fcat
project=dotrb2013

# cache images
ubuntu_universe=${user}/ubuntu-universe
ubuntu_universe_tagged=${ubuntu_universe}:12.04
rails_base=${user}/${project}-rails-base
postgresql=${user}/postgresql

# final images
postgresql_with_db=${user}/${project}-postgresql
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
	docker images ${postgresql_with_db}

pull:
	docker pull ${rails}
	docker pull ${postgresql_with_db}

push:
	docker push ${ubuntu_universe}
	docker push ${rails_base}
	docker push ${rails}
	docker push ${postgresql}
	docker push ${postgresql_with_db}

run:
	docker run ${rails}
	docker run ${postgresql_with_db}

ps:
	docker ps
