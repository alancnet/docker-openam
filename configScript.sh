adminPassword=Lifetime1
agentPassword=Lifetime2

echo Starting tomcat6
/etc/init.d/tomcat6 start

echo Starting httpd
/etc/init.d/httpd start

echo Waiting for server to start

tail -F /var/log/tomcat6/catalina.out &
sh -c 'tail -n +0 --pid=$$ -F /var/log/tomcat6/catalina.out | { sed "/Server startup in/ q" && kill $$ ;}'

echo Starting up application
curl -s -b cookies -c cookies "http://localhost:8080/openam/config/options.htm"

echo Setting admin password
curl -s -b cookies -c cookies --referer "http://localhost:8080/openam/config/options.htm" "http://localhost:8080/openam/config/defaultSummary.htm?actionLink=checkPasswords&ie7fix=3" -d "confirm=$adminPassword&password=$adminPassword&otherPassword=&type=admin"

echo
echo Setting agent password
curl -s -b cookies -c cookies --referer "http://localhost:8080/openam/config/options.htm" "http://localhost:8080/openam/config/defaultSummary.htm?actionLink=checkPasswords&ie7fix=3" -d "confirm=$agentPassword&password=$agentPassword&otherPassword=$adminPassword&type=agent"

echo
echo Creating default config

(
	echo Waiting...
	while [ ! -f /usr/share/tomcat6/openam/install.log ] ;
	do
		sleep .1
	done
	cat /usr/share/tomcat6/openam/install.log
) & (
	echo Executing!!!
	curl -s -b cookies -c cookies --referer "http://localhost:8080/openam/config/options.htm" "http://localhost:8080/openam/config/defaultSummary.htm?actionLink=createDefaultConfig"
)

echo
echo Done!
