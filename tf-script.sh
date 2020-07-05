#! /bin/bash
docker run -u $(id -u):$(id -g) -it -p 8888:8888 --mount type=bind,source="/home/mohi/workspace",target="/tf" tensorflow/tensorflow:latest-gpu-py3-jupyter
