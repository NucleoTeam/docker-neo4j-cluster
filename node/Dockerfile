# --- NEO4J CLUSTER ---

FROM debian:stretch-slim
MAINTAINER Nathaniel Davidson <nathaniel.davidson@gmail.com>

# required tools
RUN apt-get update
RUN apt-get install -y software-properties-common iproute2 wget curl

# install Java
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 8u141
ENV JAVA_DEBIAN_VERSION 8u141-b15-1~deb9u1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
	apt-get update; \
	apt-get install -y \
		openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
		ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	; \
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# install neo4j
RUN wget http://neo4j.com/artifact.php?name=neo4j-enterprise-3.2.3-unix.tar.gz -O neo4j-enterprise-3.2.3-unix.tar.gz
RUN tar -xf neo4j-enterprise-3.2.3-unix.tar.gz
RUN mkdir /var/lib/neo4j/
RUN cd neo4j-enterprise-3.2.3/; mv ./* /var/lib/neo4j/;cd ..
RUN rm -f neo4j-enterprise-3.2.3-unix.tar.gz
RUN rm -Rf neo4j-enterprise-3.2.3/

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
