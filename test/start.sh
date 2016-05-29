docker-compose up -d db portus
sleep 10
docker-compose up -d registry
docker-compose up
