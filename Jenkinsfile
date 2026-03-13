pipeline {
  agent any

  tools {
    nodejs 'NodeJS'
  }
  stages {
    stage("Checkout Code"){
      steps {
        git branch: 'main', url: 'https://github.com/gowdaamith/CI_CD_DEMO-1'
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
