stanford-corenlp-docker
=======================

This Dockerfile will build and run the most current release of the
[Stanford CoreNLP server](http://stanfordnlp.github.io/CoreNLP/corenlp-server.html) in a docker container.

Usage
=====

To download and run a [prebuilt version of the CoreNLP server](https://hub.docker.com/r/nlpbox/corenlp/)
from Docker Hub locally at ``http://localhost:8080``, just type:

```
docker run -p 8080:9000 nlpbox/corenlp
```

In order to build and run the container from scratch (e.g. if you want to use the most current release of Stanford CoreNLP, type:

```
docker build -t corenlp https://github.com/NLPbox/stanford-corenlp-docker.git
docker run -p 8080:9000 corenlp
```
