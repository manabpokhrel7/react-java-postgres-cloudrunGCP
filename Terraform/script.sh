#!/bin/bash
#gcrane copy manabpokhrel7/react-springboot:latest us-central1-docker.pkg.dev/thermal-camera-485502-u2/my-repository/react-springboot:latest
#gcrane copy manabpokhrel7/java-springboot:latest us-central1-docker.pkg.dev/thermal-camera-485502-u2/my-repository/java-springboot:latest
#gcloud iam service-accounts keys create key.json --iam-account=aml-service-account@project-5cccd6a0-b034-4117-a60.iam.gserviceaccount.com
#sleep 10
export TF_VAR_cloudamqp_apikey="dc80dec9-cbab-4d40-b524-213936acac34"
terraform apply --auto-approve