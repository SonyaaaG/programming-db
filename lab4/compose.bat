docker-compose stop
docker-compose down --volumes
rmdir /s /q "./postgres/data/"
docker-compose up -d --build
