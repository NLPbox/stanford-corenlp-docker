FROM ubuntu:16.04
MAINTAINER Arne Neumann <nlpbox.programming@arne.cl>

RUN apt-get update -y && \
    apt-get install -y git wget dtrx openjdk-8-jre python-pycurl

# install geturl script to retrieve the most current download URL of CoreNLP
WORKDIR /opt/
RUN git clone https://github.com/arne-cl/grepurl.git


# install latest CoreNLP release
RUN wget $(/opt/grepurl/grepurl -r 'zip$' -a http://stanfordnlp.github.io/CoreNLP/) && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) corenlp && rm *.zip

# install latest English language model
#
# Docker can't set an ENV to the result of a RUN command, so we'll have
# to use this workaround.
# This command get's the first model file (at least for English there are two)
# and extracts its property file.
WORKDIR /opt/corenlp
RUN wget $(/opt/grepurl/grepurl -r 'english.*jar$' -a http://stanfordnlp.github.io/CoreNLP | head -n 1)


ENV JAVA_XMX 4g
ENV PORT 9000
EXPOSE $PORT

CMD java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000
