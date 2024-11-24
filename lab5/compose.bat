docker-compose stop
docker-compose down --volumes --rmi local
rmdir /s /q "./postgres/data/"
docker-compose up -d --build
