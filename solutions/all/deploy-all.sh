#!/bin/bash

GIT_URI=${GIT_URI:-https://github.com/siamaksade/cart-service.git}
PROD_HOSTNAME_SUFFIX=${PROD_HOSTNAME_SUFFIX:-prod.10.2.2.15.nip.io}

BASE_DIR=`dirname $0`

oc new-project lab-infra --display-name="Lab Infra"
oc new-project dev --display-name="Cart Dev"
oc new-project prod --display-name="Coolstore Prod"
oc process -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus2-template.yaml | oc create -f - -n lab-infra
oc process -f $BASE_DIR/cart-template.yaml -v GIT_URI=$GIT_URI -v MAVEN_MIRROR_URL= | oc create -f - -n dev
oc process -f $BASE_DIR/coolstore-bluegreen-template.yaml -v HOSTNAME_SUFFIX=$PROD_HOSTNAME_SUFFIX | oc create -f - -n prod
oc process -f $BASE_DIR/pipeline-scm.yaml -v GIT_URI=$GIT_URI -v GIT_REF=jenkinsfiles | oc create -f - -n dev