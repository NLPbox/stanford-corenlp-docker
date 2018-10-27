stanford-corenlp-docker
=======================

This Dockerfile will build and run the most current release of the
[Stanford CoreNLP server](http://stanfordnlp.github.io/CoreNLP/corenlp-server.html) in a docker container.

Usage
=====

To download and run a [prebuilt version of the CoreNLP server](https://hub.docker.com/r/nlpbox/corenlp/)
from Docker Hub locally at ``http://localhost:9000``, just type:

```
docker run -p 9000:9000 nlpbox/corenlp
```

By default, CoreNLP will use up to 4GB of RAM. You can change this by setting
the `JAVA_XMX` environment variable. Here, we're giving it 3GB:

```
docker run -e JAVA_XMX=3g -p 9000:9000 -ti nlpbox/corenlp
```


In order to build and run the container from scratch (e.g. if you want to use the most current release of Stanford CoreNLP, type:

```
docker build -t corenlp https://github.com/NLPbox/stanford-corenlp-docker.git
docker run -p 9000:9000 corenlp
```

In another console, you can now query the CoreNLP REST API like this:

```
wget -q --post-data "Although they didn't like it, they accepted the offer." \
  'localhost:9000/?properties={"annotators":"parse","outputFormat":"json"}' \
  -O - | jq ".sentences[0].parse"
```

which will return this parse tree:

```
"(ROOT\n  (S\n    (SBAR (IN Although)\n      (S\n        (NP (PRP they))\n        (VP (VBD did) (RB n't)\n          (PP (IN like)\n            (NP (PRP it))))))\n    (, ,)\n    (NP (PRP they))\n    (VP (VBD accepted)\n      (NP (DT the) (NN offer)))\n    (. .)))"
```

If you need the full xml output and want to configure more parameters, try:

```
wget -q --post-data "Although they didn't like it, they accepted the offer." \
  'localhost:9000/?properties={ \
    "annotators":"tokenize,ssplit,pos,lemma,ner,parse", \
    "ssplit.eolonly":"false", "tokenize.whitespace":"true", \
    "outputFormat":"xml"}' \
  -O results.xml
```
