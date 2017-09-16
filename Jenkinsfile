pipeline {
  agent any
  stages {
    stage('BeginProcess') {
      steps {
        parallel(
          "BeginProcess": {
            script {
              echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Started the pipeline (<${env.BUILD_URL}|Open>)"
            }
          }
        )
      }
    }
    stage('Docker Build') {
      steps {
        parallel(
          "Build Docker Image": {
            script {
              echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Building Docker image"
            }
            sh 'docker build -t nucleoteam/neo4j-cluster:latest -t nucleoteam/neo4j-cluster:${env.BUILD_NUMBER} node/'
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
        sh 'docker push nucleoteam/neo4j-cluster:${env.BUILD_NUMBER}'
        script {
          echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Docker image published to DockerHub"
        }

      }
    }
    stage('Finished') {
      steps {
        script {
          echo "[${env.JOB_NAME} #${env.BUILD_NUMBER}] Finished pipeline"
         }

      }
    }
  }
}
