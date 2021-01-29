#!bin/bash

echo ' **** Pipenv: shell & dependences ***** '
cd /usr/src/blog_api_tutorial/
pipenv shell
pipenv install --system --deploy --skip-lock

export FLASK_ENV=development
export DATABASE_URL=postgres://postgresadmin:secret_password@postgres-service:5432/postgresdb
export JWT_SECRET_KEY=hhgaghhgsdhdhdd


echo "Creating the database config and secret..."

kubectl apply -f ./kubernetes/secret.yml
kubectl apply -f ./kubernetes/postgres-config.yml

echo "Creating the volume..."

kubectl apply -f ./kubernetes/persistent-volume.yml
kubectl apply -f ./kubernetes/persistent-volume-claim.yml

echo "Creating the postgres deployment and service..."
