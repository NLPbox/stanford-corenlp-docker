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
docker run -e JAVA_XMX=3g -p 9000:9000 -ti corenlp-docker
```


In order to build and run the container from scratch (e.g. if you want to use the most current release of Stanford CoreNLP, type:

```
docker build -t corenlp https://github.com/NLPbox/stanford-corenlp-docker.git
docker run -p 9000:9000 corenlp
```

In another console, you can now query the CoreNLP REST API like this:

```
wget -q --post-data "Deine Mutter kommt aus Wuppertal." \
  'localhost:9000/?properties={ \
    "pipelineLanguage":"german", "annotators":"parse","outputFormat":"json"}' \
  -O - | jq ".sentences[0].parse"```

which will return this parse tree:

```
"(ROOT\n  (S\n    (NP (ART Deine) (NN Mutter))\n    (VVFIN kommt)\n    (PP (APPR aus) (NE Wuppertal))\n    ($. .)))"
```

If you need the full xml output and want to configure more parameters, try:

```
wget -q --post-data "Deine Mutter kommt aus Wuppertal." \
  'localhost:9000/?properties={ \
    "pipelineLanguage":"german", \
    "annotators":"tokenize,ssplit,pos,lemma,ner,parse", \
    "ssplit.eolonly":"false", "tokenize.whitespace":"true", \
    "outputFormat":"xml"}' \
  -O results.xml
```
