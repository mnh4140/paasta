pipeline {
    agent any

    stages {
        stage('podman install') {
	   steps {
                sh 'apt-get update'
                sh 'apt-get -y upgrade' 
                sh 'apt-get -y install podman'
	   }
	}
        stage('harbor login & podman build') {
            steps {
                sh 'podman login 52.79.48.121:30002 --username admin --password Harbor12345 --tls-verify=false'
                // sh 'podman build -t tomcat:test -f signup-app/tomcat/Dockerfile .'
                sh 'podman build -t nginx:signup -f signup-app/nginx/Dockerfile .'
            }
        }
	stage('podman tag & push') {
            steps {
		sh 'podman tag tomcat:test 52.79.48.121:30002/nh-project/tomcat:harbor'
	        sh 'podman push 52.79.48.121:30002/nh-project/tomcat:harbor --tls-verify=false'
		sh 'podman tag nginx:signup 52.79.48.121:30002/nh-project/nginx:signup'
	        sh 'podman push 52.79.48.121:30002/nh-project/nginx:signup --tls-verify=false'
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
