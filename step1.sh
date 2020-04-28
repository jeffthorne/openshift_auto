#!/bin/bash

### Initial Setup

### configuraton
POSTGRES_PASSWORD=
AQUA_REGISTRY_USERNAME=
AQUA_REGISTRY_PASSWORD=
### end configuraton


# Login in as an OpenShift admin so you can run the oc adm commands:
# oc login -u system:admin
oc new-project aqua
oc create serviceaccount aqua-sa -n aqua
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:aqua:aqua-sa
oc adm policy add-scc-to-user privileged system:serviceaccount:aqua:aqua-sa
oc adm policy add-scc-to-user hostaccess system:serviceaccount:aqua:aqua-sa
oc create secret docker-registry aqua-registry --docker-server=registry.aquasec.com --docker-username=$AQUA_REGISTRY_USERNAME --docker-password=$AQUA_REGISTRY_PASSWORD --docker-email=no@email.com -n aqua
oc secrets add aqua-sa aqua-registry --for=pull -n aqua
oc create secret generic aqua-db --from-literal=password=$POSTGRES_PASSWORD -n aqua

echo "sleeping 10 seconds before creating PV and PVCs" && sleep 10
oc apply -f step2.yaml
echo "sleeping 60 seconds before deploying Postgres persistence layer" && sleep 60
oc apply -f step3.yaml
echo "sleeping 60 seconds before deploying Aqua console and gateway" && sleep 60
oc apply -f step4.yaml
echo $(oc get svc | grep aqua-web)