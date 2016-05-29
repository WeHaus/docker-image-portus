dockerfile: *.m4
	m4 Dockerfile.m4 > ../Dockerfile

build: dockerfile
	cd .. && [ -d portus ] || git clone https://github.com/SUSE/Portus.git portus
	cd ../portus && git pull
	docker build --rm -t eugenmayer/portus ../
	rm ../Dockerfile
