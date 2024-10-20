
docker run ^
  --name=lab3 ^
  --rm ^
  --env=POSTGRES_PASSWORD=postgres ^
  --env=POSTGRES_DB=lab3 ^
  -p 5434:5432 ^
  postgres:14.0 -c log_statement=all
