FROM camunda/camunda-bpm-platform:7.9.0 as base

USER root
RUN rm -rf /camunda/webapps/camunda-invoice
RUN rm -rf /camunda/webapps/examples
RUN apk add wget curl busybox-extras -f
USER camunda


FROM base as build
USER root
RUN apk add maven -f

COPY pom.xml /dependencies/
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

RUN cd /dependencies/ && \
  mvn dependency:copy-dependencies -U && \
  chown camunda:camunda -R ./*

USER camunda


FROM base
RUN cd /camunda/lib && \
    rm groovy-all-2.4.13.jar && \
    rm mail-1.4.1.jar
COPY --from=build /dependencies/*.jar /camunda/lib/
COPY /demo_processes/*.war /camunda/webapps/

RUN sed -i 's/<!-- <filter>/<filter>/' /camunda/webapps/engine-rest/WEB-INF/web.xml && sed -i 's/<\/filter-mapping> -->/<\/filter-mapping>/' /camunda/webapps/engine-rest/WEB-INF/web.xml