#!groovy
@Library('Infrastructure@branchbuilds')
import uk.gov.hmcts.contino.BuildUtils

GITHUB_PROTOCOL = "https"
GITHUB_REPO = "github.com/contino/moj-module-redis/"

properties([
    [$class       : 'GithubProjectProperty',
     projectUrlStr: "${GITHUB_PROTOCOL}://${GITHUB_REPO}"],
    pipelineTriggers([[$class: 'GitHubPushTrigger']])
])

withCredentials([string(credentialsId: 'sp_password', variable: 'ARM_CLIENT_SECRET'),
                 string(credentialsId: 'tenant_id', variable: 'ARM_TENANT_ID'),
                 string(credentialsId: 'subscription_id', variable: 'ARM_SUBSCRIPTION_ID'),
                 string(credentialsId: 'object_id', variable: 'ARM_CLIENT_ID'),
                 string(credentialsId: 'kitchen_github', variable: 'TOKEN'),
                 string(credentialsId: 'kitchen_github', variable: 'TF_VAR_token'),
                 string(credentialsId: 'kitchen_client_secret', variable: 'AZURE_CLIENT_SECRET'),
                 string(credentialsId: 'kitchen_tenant_id', variable: 'AZURE_TENANT_ID'),
                 string(credentialsId: 'kitchen_subscription_id', variable: 'AZURE_SUBSCRIPTION_ID'),
                 string(credentialsId: 'kitchen_client_id', variable: 'AZURE_CLIENT_ID')]) {
  try {
    node {
      withEnv(["GIT_COMMITTER_NAME=jenkinsmoj",
               "GIT_COMMITTER_EMAIL=jenkinsmoj@contino.io"]) {

        BuildUtils utils = new BuildUtils(this)

        stage('Checkout') {
          deleteDir()
          checkout scm
        }

        stage('Terraform Linting Checks') {
          def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
          env.PATH = "${tfHome}:${env.PATH}"
          sh 'terraform fmt --diff=true > diff.out'
          sh 'if [ ! -s diff.out ]; then echo "Initial Linting OK ..."; else echo "Linting errors found while running terraform fmt --diff=true..." && cat diff.out && exit 1; fi'
          sh 'terraform validate'
        }

//        stage('Terraform Integration Testing') {
//          sh 'date|md5sum|base64|head -c 6 > .random_string'
//          RANDOM_STRING = readFile '.random_string'
//          docker.image('contino/inspec-azure:latest').inside("-e TF_VAR_random_name=inspec${RANDOM_STRING}") {
//            sh 'echo $TF_VAR_random_name'
//            sh 'export PATH=$PATH:/usr/local/bundle/bin:/usr/local/bin && export HOME="$WORKSPACE" && cd tests/int && kitchen test azure'
//          }
//        }

        stage('Tagging') {
          String tag = utils.nextTag()
          String result = utils.applyTag(tag)
          sh "echo $result"
        }
      }
    }
  }
  catch (err) {
    throw err
  }
}
