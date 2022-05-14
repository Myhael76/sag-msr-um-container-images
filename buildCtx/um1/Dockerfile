#################################################################################
# Copyright (c) 1999 - 2011 my-Channels Ltd
# Copyright (c) 2012 - 2021 Software AG, Darmstadt, Germany and/or its licensors
#
# SPDX-License-Identifier: Apache-2.0
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#################################################################################
# --------------------------------------------------------------------------------------------------------------
# Sample Dockerfile demonstrating how to package the Universal Messaging server and tools as a Docker container.
# Version 1.0: Initial release
# Forked and adapted from https://raw.githubusercontent.com/SoftwareAG/universalmessaging-server-docker-samples/master/UM-Dockerfile/Dockerfile
# --------------------------------------------------------------------------------------------------------------

#Universal Messaging supports UBI 8 images as base image except for the ubi-micro image variant.
#read the in-line comments in Dockerfile for changes needs to be done to use UBI images as the base image.
ARG BASE_IMAGE=redhat/ubi8

# We are anticipating the copies on a temporary conatiner to save on layers
FROM alpine as packer

ARG __instance_name=umserver

ENV $INSTANCE_NAME=${__instance_name}

RUN mkdir -p \
      /tmp/product_home/common/bin/ \
      /tmp/product_home/common/conf/ \
      /tmp/product_home/common/lib/ \
      /tmp/product_home/common/metering/ \
      /tmp/product_home/common/runtime/bundles/platform/eclipse/ \
      /tmp/product_home/install/jars/ \
      /tmp/product_home/jvm/jvm/ \
      /tmp/product_home/UniversalMessaging/lib/ \
      /tmp/product_home/UniversalMessaging/server/$INSTANCE_NAME/bin \
      /tmp/product_home/UniversalMessaging/tools/runner/

COPY ./3rdPartyLicenses.pdf $SAG_HOME/3rdPartyLicenses_NUM_UniversalMessagingDocker.pdf
COPY ./common/bin/ /tmp/product_home/common/bin/
COPY ./common/conf/users.txt /tmp/product_home/common/conf/users.txt
COPY ./common/lib/ /tmp/product_home/common/lib/
COPY ./common/metering/ /tmp/product_home/common/metering/
COPY ./common/runtime/bundles/platform/eclipse/ /tmp/product_home/common/runtime/bundles/platform/eclipse/
COPY ./configure.sh /tmp/product_home/configure.sh
COPY ./install/jars/DistMan.jar /tmp/product_home/install/jars/DistMan.jar
COPY ./jvm/jvm/ /tmp/product_home/jvm/jvm/
COPY ./uminitialize.sh /tmp/product_home/uminitialize.sh
COPY ./umstart.sh /tmp/product_home/umstart.sh
COPY ./UniversalMessaging/lib/ /tmp/product_home/UniversalMessaging/lib/
COPY ./UniversalMessaging/server/$INSTANCE_NAME/bin /tmp/product_home/UniversalMessaging/server/$INSTANCE_NAME/bin
COPY ./UniversalMessaging/tools/runner/ /tmp/product_home/UniversalMessaging/tools/runner/

##############################à

FROM $BASE_IMAGE as base

ARG __data_dir=/data
ARG __sag_home=/opt/softwareag
ARG __instance_name=umserver

ENV \
    SAG_HOME=$__sag_home \
    DATA_DIR=$__data_dir \
    INSTANCE_NAME=$__instance_name \
    SAG_USER_ID=1724 \
    SAG_USER_NAME=sagadmin \
    SAG_GROUP_ID=1724 \
    SAG_GROUP_NAME=sagadmin \
    UM_HOME=$__sag_home/UniversalMessaging \
    PATH=$__sag_home:$__sag_home/jvm/jvm:$__sag_home/UniversalMessaging/tools/runner:$PATH \
    PORT=9000 \
    JMX_AGENT_PORT=9200 \
    LOG_DIR=$__sag_home/UniversalMessaging/server/$__instance_name/logs \
    LIC_DIR=$__sag_home/UniversalMessaging/server/$__instance_name/licence \
    USERS_DIR=$__sag_home/common/conf \
    SERVER_COMMON_CONF_FILE=Server_Common.conf \
    TOOLS_DIR=$__sag_home/UniversalMessaging/tools


#Universal Messaging requires shadow-utils, procps packages.
#for UBI base images uncomment the below line to install the required packages.
#for ubi-minimal images, use microdnf instead of yum.
#this change is not required for ubi-init images as the image already contains the required packages.
RUN yum install shadow-utils procps -y ;\
    yum -y update ;\
    yum clean all ;\
    groupadd -g 1724 sagadmin ;\
    useradd -u 1724 -m -g 1724 -d $SAG_HOME -c "SoftwareAG Admin" sagadmin ;\
    mkdir -p \
      $SAG_HOME \
      $DATA_DIR ;\
    chown -R 1724:1724 $SAG_HOME ;\
    chown 1724:1724 $DATA_DIR ;\
    chmod 775 $SAG_HOME

COPY --chown=$SAG_USER_ID:$SAG_GROUP_ID --from=packer /tmp/product_home/ $SAG_HOME/
RUN chgrp -R 0 $SAG_HOME && chmod -R g=u $SAG_HOME ;\
    chmod u+x $SAG_HOME/*.sh

USER $SAG_USER_ID

# Create the Persistent storage for data directory, logs directory, users directory
VOLUME \
  "$DATA_DIR", \
  "$LIC_DIR", \
  "$LOG_DIR", \
  "$USERS_DIR"

# Change the work directory, where the entry point script is present.
WORKDIR $SAG_HOME
ENTRYPOINT umstart.sh

#health monitor plugin will running on path 'http://localhost:$PORT/health/' by default in UM containers. this will be used for healthcheck.
HEALTHCHECK --interval=15s --timeout=30s --start-period=120s  CMD curl --fail http://localhost:$PORT/health/ || exit 1

EXPOSE $PORT
EXPOSE $JMX_AGENT_PORT
