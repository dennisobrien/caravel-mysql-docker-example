# caravel-mysql-docker-example
Example of using docker and docker-compose to start Caravel using MySQL.

**Note:** Currently this is demonstrating ~~a bug in Caravel~~
my inability to initialize the example datasets when using a persistent
metadata store (in this case MySQL).

https://github.com/airbnb/caravel/issues/1070

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

When the containers are started, Caravel will be reachable at
[http://localhost:8088/](http://localhost:8088/)

## Debugging

To get shell in the running docker container, first list the running processes.

```
$ docker ps
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS                    NAMES
0895fbd7ff3a        caravelmysqldockerexample_caravel   "./wait-for-it.sh db:"   8 seconds ago       Up 7 seconds        0.0.0.0:8088->8088/tcp   caravelmysqldockerexample_caravel_1
ca4098f47232        mysql:5.7                           "docker-entrypoint.sh"   9 seconds ago       Up 8 seconds        0.0.0.0:3306->3306/tcp   caravelmysqldockerexample_db_1
```

Now attach to that container process:

```
$ docker exec -it 0895fbd7ff3a bash
root@0895fbd7ff3a:/home/caravel#
```

Start an ipython shell:
```
root@0895fbd7ff3a:/home/caravel# ipython
Python 2.7.12 |Continuum Analytics, Inc.| (default, Jul  2 2016, 17:42:40) 
Type "copyright", "credits" or "license" for more information.

IPython 4.2.0 -- An enhanced Interactive Python.
?         -> Introduction and overview of IPython's features.
%quickref -> Quick reference.
help      -> Python's own help system.
object?   -> Details about 'object', use 'object??' for extra details.

In [1]: from caravel import db, models
...

In [2]: s = db.session()

In [3]: db_obj = s.query(models.Database).first()

```
