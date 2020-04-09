cd /home/ec2-user/covid-19-challenge/fhirDB/
cp patient-data.tar.gz /tmp/
/usr/bin/irissession IRIS -U USER <<EOF
intersystems
intersystems
zn "%SYS"
Write \$SYSTEM.OBJ.Load("/home/ec2-user/covid-19-challenge/fhirDB/fhirDB-atelier-project/IRISConfig/Installer.cls","ck")
w ##class(MSPConfig.FHIRInstaller).DoFHIRServerSetup("HS")
w ##class(MSPConfig.FHIRInstaller).SetupIAMUser()
w ##class(MSPConfig.FHIRInstaller).EnableIAMAPIEndpoint()
halt
EOF