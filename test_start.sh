docker-compose up -d registry
sleep 5
docker-compose up -d db
sleep 2
docker-compose up -d portus
sleep 10
docker-compose up
