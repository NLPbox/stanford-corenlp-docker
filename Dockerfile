FROM ubuntu:16.04
MAINTAINER Arne Neumann <nlpbox.programming@arne.cl>

RUN apt-get update -y && \
    apt-get install -y git wget dtrx openjdk-8-jre python-pycurl

# install geturl script to retrieve the most current download URL of CoreNLP
WORKDIR /opt/
RUN git clone https://github.com/foutaise/grepurl.git


# install stable CoreNLP release 3.9.1
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-full-2018-02-27.zip && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) corenlp && rm *.zip

# install English language model 3.9.1
WORKDIR /opt/corenlp
RUN wget http://nlp.stanford.edu/software/stanford-english-corenlp-2018-02-27-models.jar

ENV JAVA_XMX 4g
ENV PORT 9000
EXPOSE $PORT

CMD java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000
