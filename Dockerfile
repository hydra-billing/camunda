FROM camunda/camunda-bpm-platform:7.9.0 as base

SHELL ["/bin/bash", "-c"]
USER root
RUN rm -rf /camunda/webapps/camunda-invoice
RUN rm -rf /camunda/webapps/examples
RUN apk add wget curl busybox-extras -f
USER camunda
COPY --chown=camunda:camunda ./camunda.sh /camunda/
COPY context.xml /camunda/conf/


FROM base as build
USER root
RUN apk add maven openjdk8 -f

COPY pom.xml /dependencies/
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

RUN cd /dependencies/ && \
  mvn dependency:copy-dependencies -U && \
  chown camunda:camunda -R ./*

# Build demo processes
COPY demo_processes /demo_processes
RUN cd /demo_processes && \
    find ./ -type d -maxdepth 1 -mindepth 1 -exec bash -c "cd {} && ./build.sh && chown camunda:camunda -R ./*" ';'


FROM base
RUN cd /camunda/lib && \
    rm groovy-all-2.4.13.jar && \
    rm mail-1.4.1.jar
COPY --from=build /dependencies/*.jar /camunda/lib/
COPY --from=build /demo_processes/*/target/*.war /camunda/webapps/

RUN sed -i 's/<!-- <filter>/<filter>/' /camunda/webapps/engine-rest/WEB-INF/web.xml && sed -i 's/<\/filter-mapping> -->/<\/filter-mapping>/' /camunda/webapps/engine-rest/WEB-INF/web.xml

ENV DB_DRIVER=
ENV DB_HOST=
ENV DB_PORT=
ENV DB_NAME=
ENV DB_USERNAME=
ENV DB_PASSWORD=
ENV DB_URL=