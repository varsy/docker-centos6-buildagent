#!/bin/bash

rccheck() {
   if [[ $? != 0 ]]; then
      echo "Error! Stopping the script."
      exit 1
   fi
}

if [ "${TC_URL}" ]; then
   echo "TeamCity URL is provided: ${TC_URL}"
else
   TC_URL="http://buildserver.labs.intellij.net/"
   echo "TeamCity URL is not provided, using default: ${TC_URL}"
fi

wget -O /home/buildagent/buildAgent.zip ${TC_URL}/update/buildAgent.zip; rccheck

if [ ${TOKEN} ]; then
    sed -i "s/authorizationToken=.*/authorizationToken=${TOKEN}/" /home/buildagent/buildAgent/conf/buildAgent.properties
fi

unzip -q -d /home/buildagent/buildAgent /home/buildagent/buildAgent.zip; rccheck
chmod +x /home/buildagent/buildAgent/bin/*.sh

cp -p /home/buildagent/buildAgent/conf/buildAgent.dist.properties /home/buildagent/buildAgent/conf/buildAgent.properties
sed -i "s|serverUrl=.*|serverUrl=${TC_URL}|" /home/buildagent/buildAgent/conf/buildAgent.properties; rccheck


/home/buildagent/buildAgent/bin/agent.sh start

while [ ! -f /home/buildagent/buildAgent/logs/teamcity-agent.log ]; 
do 
   echo -n "."
   sleep 1
done

trap "/home/buildagent/buildAgent/bin/agent.sh stop" SIGINT SIGTERM SIGHUP

touch /root/anchor

tail -qf /home/buildagent/buildAgent/logs/teamcity-agent.log /root/anchor &
wait
