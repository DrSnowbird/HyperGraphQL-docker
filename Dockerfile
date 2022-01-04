ARG BASE=${BASE:-openkbs/java11-nonroot-docker}
FROM ${BASE}

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

#########################
#### ---- App:  ---- ####
#########################
USER ${USER:-developer}
WORKDIR ${HOME:-/home/developer}

ENV APP_HOME=${APP_HOME:-$HOME/app}
ENV APP_MAIN=${APP_MAIN:-setup.sh}
COPY --chown=$USER:$USER ./app $HOME/app

#########################################
##### ---- Setup: Entry Files  ---- #####
#########################################
COPY --chown=${USER}:${USER} docker-entrypoint.sh /
COPY --chown=${USER}:${USER} ${APP_MAIN} ${APP_HOME}/setup.sh
RUN sudo chmod +x /docker-entrypoint.sh ${APP_HOME}/setup.sh 

#########################################
##### ---- Docker Entrypoint : ---- #####
#########################################
ENTRYPOINT ["/docker-entrypoint.sh"]

#####################################
##### ---- user: developer ---- #####
#####################################
WORKDIR ${APP_HOME}
USER ${USER}

#####################################
##### ---- HyperGraphQL:   ---- #####
#####################################
# ref: http://hypergraphql.org/
#### ---- (download HGQL GIT) ---- ####
#ARG HGQL_GIT=https://github.com/hypergraphql/hypergraphql.git
ARG HGQL_GIT=https://github.com/DrSnowbird/HyperGraphQL.git
RUN git clone ${HGQL_GIT} && cd $(basename ${HGQL_GIT%%.git}) && \
    gradle clean build shadowJar && ls -al $(find ./build -name "*.jar")
    
#### ---- (download HGQL jar files to support run-demo.sh) ---- ####
#ARG HGQL_VERSION_LATEST=3.0.1
#ARG HGQL_JAR=https://github.com/hypergraphql/hypergraphql/releases/download/${HGQL_VERSION_LATEST}/hypergraphql-${HGQL_VERSION_LATEST}-exe.jar
#RUN wget -q --no-check-certificate ${HGQL_JAR}

#### ---- (Script for Evaluation demo): ---- ####
COPY --chown=${USER}:${USER} run-demo.sh ${HOME}/bin/

######################
#### (Test only) #####
######################
CMD ["/bin/bash"]
######################
#### (RUN setup) #####
######################
#CMD ["setup.sh"]

