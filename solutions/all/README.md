Continuous Delivery Lab
===
This script deploys all steps required in the labs once.

Log into the OpenShift cluster and also set the ```HOSTNAME_SUFFIX``` environment varialbe to the apps hostname used by your OpenShift cluster:
```
oc login -u developer
export HOSTNAME_SUFFIX=apps.10.2.2.15.nip.io
```

Deploy the lab app and pipline:
```
git clone https://github.com/openshift-evangelists/summit17-cicd-lab.git ~/summit17-cicd-lab
~/summit17-cicd-lab/solutions/all/deploy-all.sh
```