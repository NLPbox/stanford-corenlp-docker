
FROM nlpbox/nlpbox-base:16.04
MAINTAINER Arne Neumann <nlpbox.programming@arne.cl>

RUN apt-get update -y && \
    apt-get install -y openjdk-8-jre python-pycurl

# install geturl script to retrieve the most current download URL of CoreNLP
WORKDIR /opt/
RUN git clone https://github.com/foutaise/grepurl.git


# install latest CoreNLP release
RUN wget $(/opt/grepurl/grepurl -d -r 'zip$' -a http://stanfordnlp.github.io/CoreNLP/) && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) corenlp && rm *.zip

WORKDIR /opt/corenlp

ENV PORT 9000
EXPOSE $PORT

CMD java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer --port $PORT --timeout 10000

