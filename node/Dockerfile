# --- NEO4J CLUSTER ---

FROM ubuntu:17.04
MAINTAINER Nathaniel Davidson <nathaniel.davidson@gmail.com>

# required tools
RUN apt-get update
RUN apt-get install -y software-properties-common iproute2
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update -y
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install oracle-java8-set-default -y
RUN java -version
RUN apt-get install -y wget curl

# install neo4j
RUN wget http://neo4j.com/artifact.php?name=neo4j-enterprise-3.2.3-unix.tar.gz -O neo4j-enterprise-3.2.3-unix.tar.gz
RUN tar -xf neo4j-enterprise-3.2.3-unix.tar.gz
RUN mkdir /var/lib/neo4j/
RUN cd neo4j-enterprise-3.2.3/; mv ./* /var/lib/neo4j/;cd ..
RUN rm -f neo4j-enterprise-3.2.3-unix.tar.gz
RUN rm -Rf neo4j-enterprise-3.2.3/
RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
RUN echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
RUN apt-get update -y
RUN apt-get install -y supervisor

# cleanup
RUN apt-get autoremove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD start.sh /start.sh
ADD supervisord.conf /etc/supervisor/conf.d/neo4j.conf
ADD neo4j.properties /var/lib/neo4j/conf/neo4j.conf
ADD neo4j-server.properties /var/lib/neo4j/conf/neo4j-server.properties

ENV REMOTE_HTTP true
ENV REMOTE_SHELL true

EXPOSE 5001
EXPOSE 6001
EXPOSE 7474

CMD ["/start.sh"]
