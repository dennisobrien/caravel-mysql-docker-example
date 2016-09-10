#!/bin/bash

set -e

echo "Installed packages:"
pip freeze

echo "Creating Caravel admin user"
fabmanager create-admin --app caravel --username admin --firstname The --lastname Admin \
  --email admin@example.com --password FIXME_FIXME_FIXME

echo "Upgrading Caravel database"
caravel db upgrade

echo "Initializing Caravel"
caravel init

echo "Loading Caravel examples"
caravel load_examples

#echo "Running some debug diagnostics on the database"
#python conf/debug_db.py

echo "Starting Caravel server"
caravel runserver -p 8088 -d
