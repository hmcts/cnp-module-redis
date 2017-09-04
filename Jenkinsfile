#!groovy

GITHUB_PROTOCOL = 'https'
GITHUB_REPO = 'github.com/contino/moj-module-redis/'

properties([
    [$class       : 'GithubProjectProperty',
     projectUrlStr: "${GITHUB_PROTOCOL}://${GITHUB_REPO}"],
    pipelineTriggers([[$class: 'GitHubPushTrigger']])
])

import uk.gov.hmcts.contino.BuildHelper

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


        def buildHelp = new BuildHelper(this)

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

          def tag = buildHelp.nextTag()

          if (env.BRANCH_NAME == 'master' &&
              (currentBuild.result == null || currentBuild.result == 'SUCCESS')) {

            println "Will tag with version: " + tag
            sh "git tag -a $tag -m \"Jenkins\""
            sh "git push '${GITHUB_PROTOCOL}://${TOKEN}@${GITHUB_REPO}' --tags"
          } else
            println "Not on 'master' branch! Next succesfull build on master will be tagged with: " + tag

        }
      }
    }
  }
  catch (err) {
    throw err
  }
}
