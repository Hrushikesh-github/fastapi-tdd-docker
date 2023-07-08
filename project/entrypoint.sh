#!/bin/sh
echo "Waiting for postgres..."

#we referenced the Postgres container using the name of the service, web-db
#waits for a network connection to be established with a service named "web-db" on port 5432 before continuing execution. This script is commonly used in containerized environments, such as Docker, to ensure that dependent services are up and running before starting a particular service.
#checks if a network connection can be established with the "web-db" service on port 5432 using the nc (netcat) command. The -z option tells nc to check only for the connection status without sending any data.

while ! nc -z web-db 5432; do
  sleep 0.1
done

echo "PostgreSQL started"

#!This will execute command mentioned in docker-compose.yml
exec "$@"
