# caravel-mysql-docker-example
Example of using docker and docker-compose to start Caravel using MySQL.

**Note:** Currently this is demonstrating ~~a bug in Caravel~~
my inability to initialize the example datasets when using a persistent
metadata store (in this case MySQL).

## Requirements

- docker
- docker-compose

## Starting and Stopping

Bring the containers up and rebuild/recreate:
```
$ docker-compose up --force-recreate --build
```

Bring the containers down and wipe out the data volumes:
```
$ docker-compose down --volumes
```

This is for testing initialization of the metadata stores.  Alter
appropriately for other purposes.

Caravel is now reachable at [http://localhost:8088/](http://localhost:8088/)

