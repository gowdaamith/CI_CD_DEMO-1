# CI_CD_DEMO

Step 1: Create a Simple application 
------------------------------------

* Make a directorie in the local machine
* Chage to the directorie and initialize the directorie
* Initialize the directorie  (npm init -y)
* Create a applicatoin
* Install the dependencies
* Add the start script
* make a test folder and write the tests
* Initialize the folder for git purpose
* Add a remote repositorie
* And push the changes

  Step 2: Building the CI pipeline
  ------------------------------------
  Flow we will be doing here is:
  GitHub Push
     ↓
Jenkins Trigger
     ↓
Checkout Code
     ↓
Install Dependencies
     ↓
Run Tests

* First we will install the Jenkins
  Here we will be using the jenkins docker image

  code to install:
  docker run -d \
-p 8080:8080 \               this port is used for host and container connection 
-p 50000:50000 \             this port is used for jenkins agents (workers)
--name jenkins \     this gives the container custom name instead of assigning the random name
jenkins/jenkins:lts  this is the docker image

  Here we are using the docker image because of
  * Faster setup
  * Clean system
  * Easy setup
  * Same environment
  * Real world usage
 
    after the use just do
    >> docker rm -f jenkins
    Run again -> fressh jenkins


    Problem with normal installation:
    If something breaks:
    *Java version conflict
    *Plugin corruption
    *System dependency issues


    you can add the volume for saftey if the container crashes and some unexpected things happen

    To get into the container use
    >> docker exec -it container-id sh
    To get into  the container as the root user use this command
    >>  docker exec -u root -it  container-id bash

  Then install the required plugin

Step 3: Create a jenkins pipeline Job 
------------------------------------------
In jenkins dashboard go to the : 
>> new item - Enter the pipeline name
>> Select the pipeline


Step 4: Connect the Jenkins to the Github

In the pipeline configuration .Go to the pipeline defination and 
Select script from SCM 

Choose the SCM as GIT
Branch : main 
Script Path: 
>> Jenkinsfile

Step 4: Now create  a Jenkinsfile
------------------------------------------
In the project repository create a file : 
>> Jenkinsfile

Step 5: Tool addition 
------------------------------------------
Since we are using the Nodejs which commonly will not come installed we need to set up its tool 
so the its command will run 

Steps: 
1.Go to the jenkins dashboard 
2.Manage Jenkins 
3.Global Tool configuration 
4.Find Nodejs [ if not found install its plugin ]
5.Enable Install automcatically 

Click on Add node.js
-- Give it a name: NodeJS 
-- Select : Install automactically (so that it will be installed automaticallly When a                      pipeline needs it  
            if its not selected : you must manually install node.js on the jenkins server 
)
-- Specify the version 
-- if you want the nodejs to be installed on 32 bit architecutre then select the next option  
   or else it will be installed in the 64 architecture  [which is recommended]
-- Specify the global npm packages to install like yarn , typescript , gulp ,grunt ,webpack
-- Specify the global npm package refresh hour like 72 hours or any other hours
-- Speicfy the type of intaller you want 

The Solution 2 (Professinal method)
-------------------------------------
Use a node.js Docker build agent 

Example Jenkins file : 
pipeline {
  agnet {
    docker {
      image 'node:25
    }
  }
  stages{
    stage('Install dependencies'){
      steps  {
        sh 'npm install'
      }
    }
    stage('Runtests'){
      steps{
        sh 'npm test'
      }
    }
  }
}

                    
                    STAGE 2

Next we will add the Docker into the CI pipeline
 ----------------------------------------------------------
 Now the pipelien flow will be 
 GitHub Push
     ↓
Jenkins
     ↓
Build Node.js App
     ↓
Run Tests
     ↓
Build Docker Image
     ↓
Push Image to DockerHub

Step 1 : Create a Dockerfile 
-------------------------------
Create a dockerfile in the same path as the jenkins file

Step 2: Test the Docker locally
--------------------------------
Before the jenkins uses Docker ,Test it 

Build the image : docker build -t ci-cd-demo
Run the container: docker run -d -p 3000:3000 ci-cd-demo
Curl in the localhost : curl http://localhost:3000

Step 3: createa  dockerhub repository 
-------------------------------------
Go to the dockerhub  and create repository like : ci-cd-demo
                           or 
While push in the image if the repository doesn't exits the repo will be automatically created

Step 4: Add the docker login to Jenkins 
---------------------------------------
In Jenkins:Go to the manage Jenkknis
Here Go to :
Manage Credentials
Global
Add Credentials

And choose : Username and Password  


Step 5 - Update the Jenkins file 
--------------------------------------
Now update the Jenkins file 


pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/ci-cd-demo"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch:'main',url: 'https://github.com/yourusername/ci-cd-demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
    }
}
