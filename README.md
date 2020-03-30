# Using a FHIR Server In Conjuction with InterSystems API Manager.

### Introduction

------

Patrick to provide Inro here

### How to Run the Demo

------

The Demo can be run quickly with the following steps.

1. Acquire an Intersystems License Key that enables access to IAM. This license key needs to be added to the folder to IRISLicense in the root of the project.
2. cd into the FHIR-API_MAnagement directory where the Makefile is located.
3. Run **make build** to build the necessary images on your machine.
4. Run **make run** 



After perfomring these actions your demo should be up and running on your machine. This includes an instance of InterSystems IRIS running an underlying FHIR server, and an Instance of the Intersystems API manager.



### What will you see

------

After running the above commands you will have multipe Docker containers running on your machine. The most improtant ones are:

- Intersystems IRIS for Health running on port 9088
- InterSystems API Manager running on 8002, and 8003



### Testing Your Demo

------



To take and make sure that your FHIR Server is up and running successfully you can test that you can successfully make requests to the exposed FHIR Endpoint. A tool like Postman can be very helpful here although it is not explicitly required. A simple curl request should work as well. I have provided an example request below.



![Screen Shot 2020-02-10 at 12.08.49 PM](./TestingDemo.png)



