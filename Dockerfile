FROM ubuntu:16.04
MAINTAINER Arne Neumann <nlpbox.programming@arne.cl>

RUN apt-get update -y && \
    apt-get install -y git wget dtrx openjdk-8-jre python-pycurl

WORKDIR /opt/

# install stable CoreNLP release 3.9.1
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-full-2018-02-27.zip && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) corenlp && rm *.zip

# install German language model 3.9.1
ENV PROPERTIES_FILE StanfordCoreNLP-german.properties
WORKDIR /opt/corenlp
RUN wget http://nlp.stanford.edu/software/stanford-german-corenlp-2018-02-27-models.jar && \
    unzip -j "stanford-german-corenlp-2018-02-27-models.jar" $PROPERTIES_FILE -d .


ENV JAVA_XMX 4g
ENV PORT 9000
EXPOSE $PORT

CMD java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -serverProperties $PROPERTIES_FILE -port 9000 -timeout 15000
