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


arne@tiny-brick ~/repos/nlpbox/stanford-corenlp-docker $ docker run -p 9000:9000 -ti corenlp-docker
[main] INFO CoreNLP - --- StanfordCoreNLPServer#main() called ---
[main] INFO CoreNLP - setting default constituency parser
[main] INFO CoreNLP - warning: cannot find edu/stanford/nlp/models/srparser/englishSR.ser.gz
[main] INFO CoreNLP - using: edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz instead
[main] INFO CoreNLP - to use shift reduce parser download English models jar from:
[main] INFO CoreNLP - http://stanfordnlp.github.io/CoreNLP/download.html


# FIXME: retrieve this properly after debug
ADD stanford-german-corenlp-2018-02-27-models.jar /opt/corenlp/
RUN unzip -j "stanford-german-corenlp-2018-02-27-models.jar" "StanfordCoreNLP-german.properties" -d .


CMD java -Xmx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -serverProperties StanfordCoreNLP-german.properties -port 9000 -timeout 15000

wget --post-data 'Deine Mutter kommt aus Wuppertal.' 'localhost:9000/?properties={"pipelineLanguage":"german","annotators":"tokenize,ssplit,pos,ner,parse"}' -O -


# install latest English language model
#
# Docker can't set an ENV to the result of a RUN command, so we'll have
# to use this workaround.
# This command get's the first model file (at least for English there are two)
# and extracts its property file.
WORKDIR /opt/corenlp
ENV PROPERTIES_FILE StanfordCoreNLP-english.properties
RUN wget $(/opt/grepurl/grepurl -r 'english.*jar$' -a http://stanfordnlp.github.io/CoreNLP | head -n 1)

# RUN unzip -j $(/opt/grepurl/grepurl -r 'english.*jar$' -a http://stanfordnlp.github.io/CoreNLP | head -n 1) $PROPERTIES_FILE -d .



ENV PORT 9000
EXPOSE $PORT

CMD java -Xmx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -serverProperties $PROPERTIES_FILE -port 9000 -timeout 15000

