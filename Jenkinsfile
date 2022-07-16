pipeline {
    agent any

    stages {
        stage('Git Clone') {
            steps {
                git credentialsId: 'GIT_CREDS', url: 'https://github.com/yashhirulkar701/spring-boot-application.git'
            }
        }
        stage('Gradle Build'){
                sh './gradlew build'
        }
        stage('Copy Dockerfile to Ansible Server'){
               sshPublisher(publishers: [sshPublisherDesc(configName: 'Jenkins', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'rsync -avh  /var/lib/jenkins/workspace/apring-app/Dockerfile  root@172.31.11.37/root/docker/Dockerfile', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
        }
        stage('Dockerfile Build in Ansible Server') {
             sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''
		cd /root/docker/
		docker build -t $JOB_NAME:v1.$BUILD_ID  .
		docker push yash701/$JOB_NAME:v1.$BUILD_ID 
		docker tag $JOB_NAME:v1.$BUILD_ID  yash701/$JOB_NAME:latest
		docker push yash701/$JOB_NAME:latest 
		docker image rmi $JOB_NAME:v1.$BUILD_ID yash701/$JOB_NAME:v1.$BUILD_ID yash701/$$JOB_NAME:latest ''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
	      }
        stage('Depoying on K8S') {
		sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible playbook  /root/playbook.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
	      }
    }
}
