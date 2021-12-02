#!groovy
@Library('Infrastructure') _

try {
  node {
    env.PATH = "$env.PATH:/usr/local/bin"

    stage('Checkout') {
      deleteDir()
      checkout scm
    }

    stage('Terraform init') {
      sh 'terraform init'
    }

    stage('Terraform Linting Checks') {
      sh 'terraform fmt -check=true'
    }
  }
}
catch (err) {
  throw err
}

