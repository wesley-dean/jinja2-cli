
pipeline {
    parameters {

        string (
            name: 'image_name',
            defaultValue: 'wesleydean/jinja2-cli',
            description: 'the name of the image to tag / push'
        )

        string (
            name: 'git_credential',
            defaultValue: 'github-wesley-dean',
            description: 'the ID of the credential to use to interact with GitHub'
        )

        string (
            name: 'docker_credential',
            defaultValue: 'dockerhub-wesleydean',
            description: 'the ID of the credential to use to interact with DockerHub'
        )
    }

    environment {
        repository_url = "${GIT_URL}"
        git_credential = "$params.git_credential"
        branch         = "$params.branch"
        build_time = sh(script: 'date --rfc-3339=seconds',
            returnStdout: true).trim()
        no_proto_repo_url = sh(script: "echo '${repository_url}' | sed -Ee 's|^https?://||'",
            returnStdout: true).trim()
        GIT_SSH_COMMAND = 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

        image_name = "$params.image_name"
        docker_credential = "$params.docker_credential"

    }

    triggers {
        cron('@monthly')
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: "$BRANCH_NAME",
                credentialsId: git_credential,
                url: "${repository_url}"
            }
        }

        stage('Text File Cleanup') {
            agent {
                docker {
                    image 'cytopia/awesome-ci'
                    reuseNode true
                }
            }

            steps {
                script {
                    def tests = [
                        'file-trailing-single-newline',
                        'file-trailing-space',
                        'file-utf8'
                    ]

                    tests.each {
                        test -> sh "$test  --ignore='.git,.svn,report' --text --fix --path='.' || true"
                    }
                }
            }
        }

        stage('Semgrep') {
            agent {
                docker {
                    image 'returntocorp/semgrep'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }

            steps {
                sh "semgrep --config auto --error '${WORKSPACE}'"
            }
        }

        stage('Meta-Linter') {
            agent {
                docker {
                    image 'megalinter/megalinter:latest'
                    args "-e -v ${WORKSPACE}:/tmp/lint --entrypoint=''"
                    reuseNode true
                }
            }

            steps {
                sh '/entrypoint.sh'
            }
        }

        stage('Push Updated Code') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${git_credential}",
                passwordVariable: 'GIT_PASSWORD', // pragma: allowlist secret
                usernameVariable: 'GIT_USERNAME')]) {
                    sh 'git diff-index --quiet HEAD || git commit -nam "Apply fixes from Mega-Linter"'
                    sh 'git push https://${GIT_USERNAME}:${GIT_PASSWORD}@${no_proto_repo_url}'
                }
            }
        }

         stage ('Build') {
            steps{
                script {
                    dockerImage = docker.build image_name
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    docker.withRegistry( '', docker_credential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
