#!/bin/sh

ant -f ../whcbuild.xml && \
cp ../whctsdist/whitehouse.war ../docker && \
cp ../whctsdist/whitehouse.war ../docker/nonssl && \
cd ../docker/nonssl && \
sudo docker-compose down && \
sudo docker-compose up -d --build
