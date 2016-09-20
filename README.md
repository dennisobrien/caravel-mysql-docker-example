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

## Testing with MySQL in Docker

I wanted to use PyCharm for interactive debugging of Caravel with a
mysql database.  Here are my notes for my future self.

Note:  PyCharm can use the interpreter in a Docker container and that is
probably the best way to do this.  It's on my list.<br>
https://blog.jetbrains.com/pycharm/2015/12/using-docker-in-pycharm/

Start a mysql docker container:
```
$ docker run --name caravel-mysql -p 3306:3306 \
 -e MYSQL_ROOT_PASSWORD=FIXME_1234567890 -e MYSQL_DATABASE=db \
 -e MYSQL_USER=mysqladmin -e MYSQL_PASSWORD=FIXME_12345 \
 -e MYSQL_PORT=3306 -d mysql:5.7
```

Attach to that container with the mysql client.
```
$ docker exec -it caravel-mysql mysql --user=mysqladmin --password=FIXME_12345 db
```

Poke around the database.
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db                 |
+--------------------+
2 rows in set (0.00 sec)

mysql> use db;
Database changed
mysql> show tables
    -> ;
Empty set (0.00 sec)

mysql> show tables;
+-------------------------+
| Tables_in_db            |
+-------------------------+
| ab_permission           |
| ab_permission_view      |
| ab_permission_view_role |
| ab_register_user        |
| ab_role                 |
| ab_user                 |
| ab_user_role            |
| ab_view_menu            |
| alembic_version         |
| birth_names             |
| clusters                |
| columns                 |
| css_templates           |
| dashboard_slices        |
| dashboard_user          |
| dashboards              |
| datasources             |
| dbs                     |
| energy_usage            |
| favstar                 |
| logs                    |
| long_lat                |
| metrics                 |
| multiformat_time_series |
| query                   |
| random_time_series      |
| slice_user              |
| slices                  |
| sql_metrics             |
| table_columns           |
| tables                  |
| url                     |
| wb_health_population    |
+-------------------------+
33 rows in set (0.00 sec)

```

Tear it all down.

```
$ docker stop caravel-mysql
caravel-mysql
$ docker rm caravel-mysql
caravel-mysql
```
