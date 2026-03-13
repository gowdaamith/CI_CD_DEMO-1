pipeline {
  agent any
  stages {
    stage("Checkout Code"){
      steps {
        git 'https://github.com/gowdaamith/CI_CD_DEMO-1'
      }
    }
    stage('Install Dependencies'){
      steps {
        sh 'npm install'
      }
    }
    stage('Run tests'){
      steps{
      sh 'npm test'
      }
    }
  }
}
