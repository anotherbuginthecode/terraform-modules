#!/bin/bash

aws lambda invoke --region=eu-west-1 --function-name=$(terraform output -raw function_name) response.json
cat response.json