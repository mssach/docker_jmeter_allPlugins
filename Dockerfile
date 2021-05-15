FROM adoptopenjdk/openjdk11:alpine-jre
MAINTAINER Sachin MS

ARG JMETER_VERSION="5.4.1"
ARG JMETER_PMANAGER_VERSION="1.6"
ARG CMDRUNNER_VERSION="2.2"
ARG JMETER_HOME="/opt/jmeter"
ARG JMETER_PLUGINS_PATH="/opt/jmeter/lib/ext"

RUN wget http://apache.mirror.gtcomm.net//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
  && tar -xvzf apache-jmeter-${JMETER_VERSION}.tgz \
  && rm apache-jmeter-${JMETER_VERSION}.tgz \
  && mv apache-jmeter-${JMETER_VERSION} ${JMETER_HOME}

RUN sed -i 's/#CookieManager.save.cookies=false/CookieManager.save.cookies=true/g' /opt/jmeter/bin/jmeter.properties

# Install plugins
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PMANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PMANAGER_VERSION}.jar \
  && mv ./jmeter-plugins-manager-${JMETER_PMANAGER_VERSION}.jar ${JMETER_HOME}/lib/ext \
  && wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar \
  && mv ./cmdrunner-${CMDRUNNER_VERSION}.jar ${JMETER_HOME}/lib \
  && java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PMANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  #Throughput Shapoing time
  && ${JMETER_HOME}/bin/PluginsManagerCMD.sh install jpgc-tst \
  && ${JMETER_HOME}/bin/PluginsManagerCMD.sh install-all-except ulp-jmeter-videostreaming-plugin,ulp-jmeter-autocorrelator-plugin,ulp-jmeter-gwt-plugin
 
RUN mv /jmeter.log /opt/jmeter/bin/

ENV JMETER_HOME ${JMETER_HOME}
ENV PATH ${JMETER_HOME}/bin:$PATH

WORKDIR	${JMETER_HOME}/bin
