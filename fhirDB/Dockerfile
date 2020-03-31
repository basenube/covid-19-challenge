FROM intersystemsdc/irisdemo-base-irishealthint-community:version-1.7.1

LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

USER root
#Need to install curl for performing automatic Swagger Spec Loading
RUN apt-get update && apt-get install -y curl

# Going back to irisowner now
USER irisowner
# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=fhirDB-atelier-project

# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Adding Synthea FHIR Pateint medical histories for consumption by FHIR Server
ADD --chown=irisowner:irisuser ./patient-data.tar.gz /tmp/

# Adding IAM folder for automatic FHIR API Spec loading
ADD --chown=irisowner:irisuser ./IAM /IAM/

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh