#!/usr/bin/env bash
sudo docker stack deploy -c=/home/ubuntu/bookface2.0/docker-compose2.0.yml bf;
sleep 5
echo "Start"
docker run -it --rm --network=bf_web cockroachdb/cockroach:v2.1.6 init --host=cockroachdb-1 --insecure
docker run -i --rm --network=bf_web cockroachdb/cockroach:v2.1.6 sql --host=cockroachdb-1 --insecure <<EOF
CREATE DATABASE bf;
CREATE USER bfuser;
GRANT ALL ON DATABASE bf TO bfuser;
USE bf;
CREATE table users ( userID INT PRIMARY KEY DEFAULT unique_rowid(), name STRING(50), picture STRING(300), status STRING(10), posts INT, comments INT, lastPostDate TIMESTAMP DEFAULT NOW(), createDate TIMESTAMP DEFAULT NOW());
CREATE table posts ( postID INT PRIMARY KEY DEFAULT unique_rowid(), userID INT, text STRING(300), name STRING(150), postDate TIMESTAMP DEFAULT NOW());
CREATE table comments ( commentID INT PRIMARY KEY DEFAULT unique_rowid(), postID INT, userID INT, text STRING(300),  postDate TIMESTAMP DEFAULT NOW());
EOF
