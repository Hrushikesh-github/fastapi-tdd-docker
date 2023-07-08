# pull official base image
FROM postgres:15

# run create.sql on init
# docker-entrypoint-initdb.d is a special directory in this docker image
# that executes any .sql files in it
ADD create.sql /docker-entrypoint-initdb.d
