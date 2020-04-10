cd /home/ec2-user/covid-19-challenge/fhirDB/
/usr/bin/irissession IRIS -U USER <<EOF
intersystems
intersystems
zn "%SYS"
Write \$SYSTEM.OBJ.Load("/home/ec2-user/covid-19-challenge/fhirDB/fhirDB-atelier-project/IRISConfig/Installer.cls","ck")
w ##class(MSPConfig.FHIRInstaller).DoFHIRServerSetup("USER")
w ##class(MSPConfig.FHIRInstaller).SetupIAMUser()
w ##class(MSPConfig.FHIRInstaller).EnableIAMAPIEndpoint()
halt
EOF