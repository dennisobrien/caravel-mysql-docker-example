#!/bin/bash

set -e

echo "Creating Caravel admin user"
fabmanager create-admin --app caravel --username admin --firstname The --lastname Admin \
  --email admin@example.com --password FIXME_FIXME_FIXME

echo "Upgrading Caravel database"
caravel db upgrade

echo "Initializing Caravel"
caravel init

echo "Loading Caravel examples"
caravel load_examples

echo "Starting Caravel server"
caravel runserver -p 8088
