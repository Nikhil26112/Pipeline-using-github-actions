# Demo-Project

## Pre-requisites
- AWS
- ECR
- ECS
- Terraform
- Github Actions
- CI/CD
- Express


In this project, I build a code deployment pipeline for the demo express app. I containerized the Application and uploaded it to ECR(Elastic Conatiner Registry). I used GitHub Actions to create the CI/CD of the project to build, test, and deploy. I created all the services using terraform script on Aws (ECS + Fargate). I validated the code deployment pipeline by making a test change by committing or merging the changes to the master git branch and code changes are reflected in the target cloud environment. 
