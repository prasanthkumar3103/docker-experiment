#!/bin/bash

# launch MongoDB, don't map any ports and use /tmp/mongodb-data for persistent storage
docker run --detach --hostname="mongodb" --name="mongodb" --memory="256m" --volume /tmp/mongodb-data:/data mongo:latest 

# launch RabbitMQ, don't map any ports and use /tmp/rabbitmq for persistent storage
docker run --detach --hostname="rabbitmq" --name="rabbitmq" --memory="256m" --volume /tmp/rabbitmq/log:/data/log --volume /tmp/rabbitmq/mnesia:/data/mnesia kurron/rabbitmq:3.3.5 

# launch Redis, don't map any ports and use /tmp/redis for persistent storage
docker run --detach --hostname="redis" --name="redis" --memory="256m" --volume /tmp/redis-data:/data redis:latest

# launch the application, map its port to localhost:8080 and have Docker take care of mapping the MongoDB and RabbitMQ ports to this container
# Noticed that we use an alias for mongodb. That is because by default the application is expecting a hostname of mongo for the database
docker run --detach --hostname="micro-service" --name="micro-service" --memory="256m" --publish 8080:8080 --link mongodb:mongo --link rabbitmq:rabbitmq  --link redis:redis kurron/example-micro-service:0.0.0
