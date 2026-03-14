pipeline {
  agent any 
  tools {
    nodejs "NodeJS"
  }
  environment {
      DOCKER_IMAGE = "gowdaamith/ci-cd-demo1:${BUILD_NUMBER}"
      SONAR_SERVER = "sonarqube-server"
  }
  stages{
    stage('Checkout'){
      steps {
        git branch: 'main', url: 'https://github.com/gowdaamith/CI_CD_DEMO-1'
      }
    }
    stage('Install the dependencies'){
      steps {
        sh 'npm ci'
      }
    }
    stage('Code Scan -SonarQube'){
      steps {
        withSonarQubeEnv("${SONAR_SERVER}"){
          sh '''
          npx sonar-scanner \
          -Dsonar.projectKey=ci-cd-demo \
          -Dsonar.sources=. \
          -Dsonar.host.url=$SONAR_HOST_URL \
          -Dsonar.login=$SONAR_AUTH_TOKEN
          '''
        }
      }
    }
    stage('Dependency scan'){
      step{
        sh 'npm audit'
      }
    }
    stage('Run tests'){
      steps {
        sh 'npm test'
      }
    }
    stage('Build the docker image'){
      steps {
        sh 'docker build -t $DOCKER_IMAGE . '
      }
    }
    stage('Image Scannign'){
      steps {
        sh 'trivy image $DOCKER_IMAGE '
    }
    stage('Push Docker images'){
      steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub',
            usernameVariable: 'USERNAME',
            passwordVariable: 'PASSWORD'
        )]) {
            sh ' echo $PASSWORD | docker login -u $USERNAME --password-stdin'
            sh 'docker push $DOCKER_IMAGE'
        }
      }
    }
  }
}



