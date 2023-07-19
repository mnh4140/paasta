pipeline {
    agent any

    stages {
        stage('podman install') {
	   steps {
		sh '. /etc/os-release'
                sh 'echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list'
                sh 'curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add -'
                sh 'apt-get update'
                sh 'apt-get -y upgrade' 
                sh 'apt-get -y install podman'
	   }
        stage('harbor login & podman build') {
            steps {
                sh 'podman login 52.79.48.121:30002 --username admin --password Harbor12345 --tls-verify=false'
                sh 'sudo podman build -t tomcat:test -f signup-app/tomcat/Dockerfile .'
                sh 'sudo podman build -t nginx:signup -f signup-app/nginx/Dockerfile .'
            }
        }
		stage('podman tag & push') {
            steps {
		sh 'sudo podman tag tomcat:test 52.79.48.121:30002/ajp-repository/tomcat:harbor'
	        sh 'sudo podman push 52.79.48.121:30002/ajp-repository/tomcat:harbor --tls-verify=false'
		sh 'sudo podman tag nginx:signup 52.79.48.121:30002/ajp-repository/nginx:signup'
	        sh 'sudo podman push 52.79.48.121:30002/ajp-repository/nginx:signup --tls-verify=false'
            }
        }
		stage('deployment') {
            steps {
                sh 'kubectl apply -f signup-app/yaml/ingress.yaml'
                sh 'kubectl apply -f signup-app/yaml/tomcat/tomcat-service.yaml'
		sh 'kubectl apply -f signup-app/yaml/tomcat/tomcat-deployment.yaml'
	        sh 'kubectl rollout restart deployment tomcat-deployment -n ajp-namespaces'

                sh 'kubectl apply -f signup-app/yaml/nginx/nginx-configmap.yaml'
                sh 'kubectl apply -f signup-app/yaml/nginx/nginx-service.yaml'
	        sh 'kubectl apply -f signup-app/yaml/nginx/nginx-deployment.yaml'
	        sh 'kubectl rollout restart deployment hello-nginx -n ajp-namespaces'
            }
        }
    }
}
