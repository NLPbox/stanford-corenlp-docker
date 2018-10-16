FROM alpine:3.8 as builder
MAINTAINER Arne Neumann <nlpbox.programming@arne.cl>

RUN apk update && \
    apk add git wget openjdk8-jre-base py2-pip py2-curl && \
    pip install setuptools

# install geturl script to retrieve the most current download URL of CoreNLP
WORKDIR /opt
RUN git clone https://github.com/arne-cl/grepurl.git
WORKDIR /opt/grepurl
RUN python setup.py install

# install CoreNLP release 3.9.2
WORKDIR /opt
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) corenlp && rm *.zip

# install English language model 3.9.2
#
WORKDIR /opt/corenlp
RUN wget http://nlp.stanford.edu/software/stanford-english-corenlp-2018-10-05-models.jar


# only keep the things we need to run CoreNLP
FROM alpine:3.8

RUN apk update && apk add openjdk8-jre-base

WORKDIR /opt/corenlp
COPY --from=builder /opt/corenlp .

ENV JAVA_XMX 4g
ENV PORT 9000
EXPOSE $PORT

CMD java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000
