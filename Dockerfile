FROM camunda/camunda-bpm-platform:7.9.0
USER root

RUN rm -rf /camunda/webapps/camunda-invoice /camunda/webapps/examples

COPY --chown=camunda:camunda ./camunda-latera-1.2.jar /camunda/lib/
COPY --chown=camunda:camunda ./demo_processes/        /camunda/webapps/

RUN apk add wget -fy
RUN cd /camunda/lib && \
  rm groovy-all-2.4.13.jar && \
  rm mail-1.4.1.jar && \
  wget http://central.maven.org/maven2/org/codehaus/groovy/groovy-all/2.4.16/groovy-all-2.4.16.jar && \
  wget http://central.maven.org/maven2/org/codehaus/groovy/modules/http-builder/http-builder/0.7.1/http-builder-0.7.1.jar && \
  wget http://central.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.6/httpclient-4.5.6.jar && \
  wget http://central.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.10/httpcore-4.4.10.jar && \
  wget http://central.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar && \
  wget http://central.maven.org/maven2/net/sf/json-lib/json-lib/2.4/json-lib-2.4-jdk15.jar && \
  wget http://maven.thingml.org/thirdparty/org/eclipse/maven/org.apache.xml.resolver/3.8.0/org.apache.xml.resolver-3.8.0.jar && \
  wget http://central.maven.org/maven2/commons-lang/commons-lang/2.5/commons-lang-2.5.jar && \
  wget http://central.maven.org/maven2/net/sf/ezmorph/ezmorph/1.0.6/ezmorph-1.0.6.jar && \
  wget http://central.maven.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar && \
  wget http://central.maven.org/maven2/commons-beanutils/commons-beanutils/1.8.0/commons-beanutils-1.8.0.jar && \
  wget http://central.maven.org/maven2/org/codehaus/groovy/groovy-json/2.4.16/groovy-json-2.4.16.jar && \
  wget http://central.maven.org/maven2/org/codehaus/groovy/groovy-xmlrpc/0.8/groovy-xmlrpc-0.8.jar && \
  wget http://central.maven.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar && \
  wget http://central.maven.org/maven2/io/github/http-builder-ng/http-builder-ng-core/1.0.3/http-builder-ng-core-1.0.3.jar && \
  wget http://central.maven.org/maven2/javax/mail/mail/1.4.7/mail-1.4.7.jar && \
  wget https://repo.maven.apache.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar && \
  wget https://repo.maven.apache.org/maven2/io/minio/minio/6.0.8/minio-6.0.8.jar && \
  wget https://repo.maven.apache.org/maven2/com/google/http-client/google-http-client-xml/1.24.1/google-http-client-xml-1.24.1.jar && \
  wget https://repo.maven.apache.org/maven2/com/google/http-client/google-http-client/1.24.1/google-http-client-1.24.1.jar && \
  wget https://repo.maven.apache.org/maven2/com/squareup/okio/okio/1.17.2/okio-1.17.2.jar && \
  wget https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp/3.13.1/okhttp-3.13.1.jar && \
  wget https://repo.maven.apache.org/maven2/com/google/guava/guava/25.1-jre/guava-25.1-jre.jar && \
  wget https://repo.maven.apache.org/maven2/xpp3/xpp3/1.1.4c/xpp3-1.1.4c.jar

RUN chown camunda:camunda /camunda/lib/*.jar
RUN sed -i 's/<!-- <filter>/<filter>/' /camunda/webapps/engine-rest/WEB-INF/web.xml && sed -i 's/<\/filter-mapping> -->/<\/filter-mapping>/' /camunda/webapps/engine-rest/WEB-INF/web.xml

RUN apk add -f curl libxml2-utils
USER camunda