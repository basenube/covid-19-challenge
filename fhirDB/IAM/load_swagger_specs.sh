#!/bin/bash
cd /IAM/OpenFHIRAPIDefinitions

service_up=0
call_number=0

while [[ $service_up -ne 1 && $call_number -le 30 ]]
do
    echo "Performing Health Check On http://localhost:8001/files/"
    call_number=$((call_number+1))
    echo "Performing call number $call_number"
    service_response_code=$(curl -s -i -w '%{response_code}' -o /dev/null -X GET --url http://localhost:8001/files/)
    echo "Service Response Code is: $service_response_code"
    if [ "$service_response_code" == "200" ]; then
        service_up=1
        echo 'Service is up'
        for filename in * ; do
            curl -s -o /dev/null -X POST http://localhost:8001/files \
                -F "type=spec" \
                -F "name=${filename%%.*}_API_Spec" \
                -F "contents=@${filename}"
        done
        echo 'Finished sending Open API Specs'
    else 
        echo "Error Status Code Recieved"
        if [ "$service_response_code" != "000" ]; then
            echo 'Service is Up but there is an error'
            service_up=1
            exit 0
        else 
            echo 'Service is Down, Monitoring will continue....'
        fi
    fi
    sleep 2
done
exit 0