configure and run ./step1.sh which automates steps 1-4.<br/>
oc apply -f step5-enforcers.yaml<br/>
oc apply -f step6-scanners.yaml  #replicas set for 3. Adjust as needed and create scanner user.<br/><br/>

**tested and confirmed with Aqua 5.0.20181 against an OS 4.2 cluster