pipeline {
    agent any

    stages {
        stage('Git Clone') {
            steps {
                git credentialsId: 'GIT_CREDS', url: 'https://github.com/yashhirulkar701/spring-boot-application.git'
            }
        }
        stage('Gradle Build') {
            agent {
	            docker {
		            image 'openjdk:11'
	            }
            }
            steps {
                sh './gradlew build'
            }
        }
        stage('Copy file in Ansible') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Jenkins', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'rsync -avh  /var/lib/jenkins/workspace/spring-app  root@43.204.230.244:/root/', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
        stage('Dockerfile Build on Ansible') {
            steps {
              sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''cd spring-app
                docker build -t $JOB_NAME:v1.$BUILD_ID .
                docker tag $JOB_NAME:v1.$BUILD_ID yash701/$JOB_NAME:v1.$BUILD_ID
                docker image push  yash701/$JOB_NAME:v1.$BUILD_ID
                docker tag $JOB_NAME:v1.$BUILD_ID  yash701/$JOB_NAME:latest
                docker image push yash701/$JOB_NAME:latest
                docker image rmi $JOB_NAME:v1.$BUILD_ID yash701/$JOB_NAME:v1.$BUILD_ID yash701/$JOB_NAME:latest''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
        stage('Deploying on K8S') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible playbook /root/playbook.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])  
            }
        }
    }
}
