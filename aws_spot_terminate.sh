#!/bin/bash
# modified from https://aws.amazon.com/blogs/compute/tag/spot/
while :; do
  curl -s http://instance-data/latest/meta-data/spot/termination-time \
  | grep -q .*T.*Z && {
    /env/bin/runterminationscripts.sh
    sleep 300
  }
  sleep 5
done