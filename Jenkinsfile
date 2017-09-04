#!groovy

GITHUB_PROTOCOL = 'https'
GITHUB_REPO = 'www.github.com/contino/moj-module-redis/'

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
        stage('Checkout') {
          deleteDir()
          checkout scm
          sh "echo '${GITHUB_PROTOCOL}://${TOKEN}@${GITHUB_REPO}'"
          sh "echo ${params}"
          sh "echo ${params.projectUrlStr}"
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

//        stage('Tagging') {
//          if (env.BRANCH_NAME == 'master' && currentBuild.result == null || currentBuild.result == 'SUCCESS') {
//            sh 'git tag -a 0.0.$BUILD_NUMBER -m "Jenkins"'
//            sh "git push '${GITHUB_PROTOCOL}://${TOKEN}@${GITHUB_REPO}' --tags"
//
//            def fetchTags = sh(script: 'git fetch "https://$TOKEN@github.com/contino/moj-module-webapp.git" --tags', returnStdout: true).split("\r?\n")
//            /*
//            // Not working because of old GIT version on Jenkins server that doesn't know --sort
//            // would be most reliable solution to get last tag
//            def lines = sh(script: 'git tag --list --sort="version:refname" -n0', returnStdout: true).split("\r?\n")
//            println lines*/
//
//            def lastTagVersion = sh(script: 'git describe --tags $(git rev-list --tags --max-count=1)', returnStdout: true)
//            println "Acquired last tag version: " + lastTagVersion
//            def lastTagSplit = lastTagVersion.split(/\./)
//            lastTagSplit[lastTagSplit.length - 1] = lastTagSplit[lastTagSplit.length - 1].toInteger() + 1
//            def nextVersion = lastTagSplit.join('.')
//
//            if (env.BRANCH_NAME == 'master' &&
//                (currentBuild.result == null || currentBuild.result == 'SUCCESS')) {
//
//              println "Will tag with version: " + nextVersion
//              sh "git tag -a $nextVersion -m \"Jenkins\""
//              sh 'git push "https://$TOKEN@github.com/contino/moj-module-redis.git" --tags'
//            } else
//              println "Not on 'master' branch otherwise would have tagged with version: " + nextVersion
//
//          }
        }
      }
    }
  }
  catch (err) {
    throw err
  }
}
