pipeline {
    agent any

    stages {
        stage('harbor login') {
            steps {
                sh 'sudo podman login 52.79.48.121:30002 --username admin --password Harbor12345 --tls-verify=false'
            }
        }

        stage('build') {
            steps {
                sh 'sudo podman build --tag 52.79.48.121:30002/nh-project/nhimage:test .'
            }
        }

        stage('harbor push') {
            steps {
                sh 'sudo podman push 52.79.48.121:30002/nh-project/nhimage:test --tls-verify=false'
            }
        }

	stage('deploy') {
            steps {
                sh 'kubectl apply -f jenkins-test.yaml'
            }
        }
    }
}

