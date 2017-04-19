#!/bin/bash

GIT_URI=${GIT_URI:-https://github.com/siamaksade/cart-service.git}
HOSTNAME_SUFFIX=${HOSTNAME_SUFFIX:-10.2.2.15.nip.io}

BASE_DIR=`dirname $0`

oc new-project lab-infra --display-name="Lab Infra"
oc new-project dev --display-name="Cart Dev"
oc new-project prod --display-name="Coolstore Prod"

oc process -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus2-template.yaml | oc create -f - -n lab-infra
oc set resources dc/nexus --limits=cpu=1,memory=2Gi --requests=cpu=200m,memory=1Gi -n lab-infra

oc process -f https://raw.githubusercontent.com/OpenShiftDemos/gogs-openshift-docker/master/openshift/gogs-persistent-template.yaml -v SKIP_TLS_VERIFY=true -v HOSTNAME=gogs-lab-infra.$HOSTNAME_SUFFIX -v GOGS_VERSION=0.9.113 -n lab-infra | oc create -f - -n lab-infra

oc process -f $BASE_DIR/cart-template.yaml -v GIT_URI=$GIT_URI -v MAVEN_MIRROR_URL= | oc create -f - -n dev
oc process -f $BASE_DIR/coolstore-bluegreen-template.yaml -v HOSTNAME_SUFFIX=prod.$HOSTNAME_SUFFIX | oc create -f - -n prod
oc process -f $BASE_DIR/pipeline-scm.yaml -v GIT_URI=$GIT_URI -v GIT_REF=jenkinsfiles | oc create -f - -n dev
oc policy add-role-to-user edit system:serviceaccount:dev:jenkins -n prod
