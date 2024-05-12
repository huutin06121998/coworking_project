# Udacity project

#1. Set Up a Postgres Database
1.Pre-requisites:
	Have Kubernetes cluster ready
	Have kubectl installed and configured to interact with this cluster.
	Installed psql

2. Create 3  yaml files(yaml/pvc.yaml, yaml/pv.yaml, yaml/postgresql-deployment.yaml
3. apply 3 files in kubectl  (replace username,password,databas as correct values)
	kubectl apply -f pvc.yaml
	kubectl apply -f pv.yaml
	kubectl apply -f postgresql-deployment.yaml

4. check deploy database sucess by get pod 
	kubectl get pods
5. open bash database to change username, password ( )  
	kubectl exec -it <postgresql- pod-name> -- bash
	psql -U myuser -d mydatabase
 
6. create yaml file as yaml/postgresql-service.yaml, then apply to kubectl  (make sure name service correct as pod) 
	kubectl apply -f postgresql-service.yaml
	
7. open forward port to open connect to this database 
	kubectl port-forward service/postgresql-service 5433:5432 &
8 go to db folder , excute 3 command below to create table and insert data 
	psql --host 127.0.0.1 -U postgres -d coworking -p 5433 < 1_create_tables.sql
	psql --host 127.0.0.1 -U postgres -d coworking -p 5433 < 2_seed_users.sql
	psql --host 127.0.0.1 -U postgres -d coworking -p 5433 < 3_seed_tokens.sql
9. test database 

#2. docker files
- please refer the file "Dockerfile" 

#3. Write a simple build pipeline with AWS CodeBuild to build and push a Docker image into AWS ECR.
	step 1: commit a source code to git branch https://github.com/huutin06121998/coworking_project.git
	step 2: create an repositories in ECR 
	Step 3: create codebuild
		- pull code from git branch above 
		- make sure buildspec correct with ECR above
		- assign permission to userole corresponding to manage ECR image   
	
	1. Take a screenshot of AWS CodeBuild pipeline for your project submission. 
		- please refer screenshot/build.png
	2. Take a screenshot of AWS ECR repository for the application's repository.
		- please refer screenshot/ECR.png
#4. Create a service and deployment using Kubernetes configuration files to deploy the application.
		- please refer YAML files. (postgresql-service.yaml, postgresql-deployment.yaml)
		- excuete kubectl to apply database service :
			kubectl apply -f postgresql-deployment.yaml
			kubectl apply -f postgresql-service.yaml
		- Deploy the application using the  coworking.yaml , configmap.yaml (inlcude Secret)
		(make sure correct data DB_USERNAME, DB_HOST, DB_NAME , DB_HOST, DB_PORT, DB_PASSWORD and  image in coworking.yaml also ) 
			kubectl apply -f configmap.yaml
			kubectl apply -f coworking.yaml
#5. You'll submit all the Kubernetes config files used for deployment 
	2 Take a screenshot of running the kubectl get svc command.
		- please refer screenshot/kubectl get svc.png		
	3 Take a screenshot of kubectl get pods.
		- please refer screenshot/kubectl get pod.png
	4 Take a screenshot of kubectl describe svc <DATABASE_SERVICE_NAME>.
		- please refer screenshot/kubectl get svc dabatabase.png
	5 Take a screenshot of kubectl describe deployment <SERVICE_NAME>.
		- please refer screenshot/describe deployment service coworking.png and screenshot/describe deployment service.png
#6. Check AWS CloudWatch for application logs.
	step 1. Attach the CloudWatchAgentServerPolicy IAM policy to worker nodes:
		aws iam attach-role-policy --role-name eksctl-cluser-coworking-nodegroup-luna-NodeInstanceRole-Q2EzZ6ul5lGk --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy 
	step 2. Use AWS CLI to install the Amazon CloudWatch Observability EKS add-on:
		aws eks create-addon --addon-name amazon-cloudwatch-observability --cluster-name cluser-coworking

	Step 3. Trigger logging by accessing your application
		curl a5b6fff8da3e94dbda373d72bcb143a8-358430639.us-east-1.elb.amazonaws.com/api/reports/daily_usage
	Step 4: Open up CloudWatch Log groups page
			CloudWatch>Log groups, we see the new logs  (/aws/containerinsights/cluster-coworking/performance)
 
	Take a screenshot of AWS CloudWatch Container Insights logs for the application.
	please refer screenshot/cloudwatch.png

#Stand-Out Suggestions	
	1. Specify reasonable Memory and CPU allocation in the Kubernetes deployment configuration
		- depend on resource requirements of your application, expected load, available resources in the cluster, and any performance considerations. They can be diffirence with production environemnt, test, dev. Following resource matrix log, we can increase(reduce)resource, (example limit resource container, replicas) 	

	2 In your README, specify what AWS instance type would be best used for the application? Why?
		- Alerts on Costly Resources, it helps me to avoid over budget 
 
	3 In your README, provide your thoughts on how we can save on costs?
		- Implement Autoscaling can adjust number of replicas base on resource matrix, system can auto scale up/down base one resource matrix , it help us to saving cost 
		- mornitor resource matrix to change configue, if need 