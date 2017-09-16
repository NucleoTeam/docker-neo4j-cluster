pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        parallel(
          "Build Docker Image": {
            script {
              echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Building Docker image"
            }
            sh "docker build -t=nucleoteam/neo4j-cluster:latest node/"
            script {
              echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Built Docker image"
            }
          }
        )
      }
    }
    stage('Publish Latest Image') {
      steps {
        script {
          echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Docker image publishing to DockerHub"
        }
        sh 'docker push nucleoteam/neo4j-cluster:latest'
        script {
          echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Docker image published to DockerHub"
        }

      }
    }
  }
}
