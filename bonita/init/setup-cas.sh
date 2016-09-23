#!/bin/bash
set -e
# Path to deploy the Tomcat Bundle
BONITA_PATH=${BONITA_PATH:-/opt/bonita}
BONITA_HOME_COMMON_PATH=${BONITA_HOME_COMMON_PATH:-/opt/bonita_home}

echo 'BonitaAuthentication-1 { 
  org.jasig.cas.client.jaas.CasLoginModule required 
    ticketValidatorClass="org.jasig.cas.client.validation.Cas20ServiceTicketValidator" 
    casServerUrlPrefix="http://cas:8080/cas" 
    tolerance="20000" 
    service="http://192.168.1.35/bonita/loginservice" 
    defaultRoles="admin,operator" 
    roleAttributeNames="memberOf,eduPersonAffiliation" 
    principalGroupName="CallerPrincipal" 
    roleGroupName="Roles" 
    cacheAssertions="true" 
    cacheTimeout="480"; 
};' > ${BONITA_PATH}/BonitaBPMSubscription-${BONITA_VERSION}-Tomcat-${TOMCAT_VERSION}/conf/jaas-standard.cfg

wget -O ${BONITA_PATH}/BonitaBPMSubscription-${BONITA_VERSION}-Tomcat-${TOMCAT_VERSION}/lib/cas-client-core-3.3.3.jar http://central.maven.org/maven2/org/jasig/cas/client/cas-client-core/3.3.3/cas-client-core-3.3.3.jar

echo 'authentication.service.ref.name=jaasAuthenticationService' > ${BONITA_HOME_COMMON_PATH}/engine-server/conf/tenants/template/bonita-tenant-sp-custom.properties
echo 'authentication.service.ref.name=jaasAuthenticationService' > ${BONITA_HOME_COMMON_PATH}/engine-server/conf/tenants/1/bonita-tenant-sp-custom.properties
 

sed -i '1{s/^/\#/g};7{s/#//g;}' ${BONITA_HOME_COMMON_PATH}/client/platform/tenant-template/conf/authenticationManager-config.properties
#sed -i '1{s/^/\#/g};7{s/#//g;}' ${BONITA_HOME_COMMON_PATH}/client/tenants/1/conf/authenticationManager-config.properties
echo "" >> ${BONITA_HOME_COMMON_PATH}/client/platform/tenant-template/conf/authenticationManager-config.properties
echo "Cas.serverUrlPrefix = http://192.168.1.35/cas" >> ${BONITA_HOME_COMMON_PATH}/client/platform/tenant-template/conf/authenticationManager-config.properties
echo "Cas.bonitaServiceURL = http://192.168.1.35/bonita/loginservice" >> ${BONITA_HOME_COMMON_PATH}/client/platform/tenant-template/conf/authenticationManager-config.properties

#echo "" >> ${BONITA_HOME_COMMON_PATH}/client/tenants/1/conf/authenticationManager-config.properties
#echo "Cas.serverUrlPrefix = http://192.168.1.35/cas" >> ${BONITA_HOME_COMMON_PATH}/client/tenants/1/conf/authenticationManager-config.properties
#echo "Cas.bonitaServiceURL = http://192.168.1.35/bonita/loginservice" >> ${BONITA_HOME_COMMON_PATH}/client/tenants/1/conf/authenticationManager-config.properties

sed -i "s/bonitasoft.level = WARNING/bonitasoft.level = FINEST/g"  ${BONITA_PATH}/BonitaBPMSubscription-${BONITA_VERSION}-Tomcat-${TOMCAT_VERSION}/conf/logging.properties