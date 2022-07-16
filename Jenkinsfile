node {

    stage("Git Clone"){

        git credentialsId: 'GIT_CREDS', url: 'https://github.com/yashhirulkar701/spring-boot-application.git'
    }

     stage('Gradle Build') {
       
       sh './gradlew build'

    }

    stage("Docker build"){
        sh 'docker version'
        sh 'docker build -t spring-app .'
        sh 'docker image list'
        sh 'docker tag yash701/spring-app'
    }

    withCredentials([string(credentialsId: 'DOCKER_CREDS', variable: 'PASSWORD')]) {
        sh 'docker login -u yash701 -p $PASSWORD'
    }

    stage("Push Image to Docker Hub"){
        sh 'docker push  yash701/spring-app'
    }

    stage("SSH Into k8s Server") {
        def remote = [:]
        remote.name = 'K8S master'
        remote.host = '172.31.37.227'
        remote.user = 'root'
        remote.password = 'redhat'
        remote.allowAnyHosts = true

        stage('Put k8s-spring-boot-deployment.yml onto k8smaster') {
            sshPut remote: remote, from: 'k8s-spring-boot-deployment.yml', into: '.'
        }

        stage('Deploy spring boot') {
          sshCommand remote: remote, command: "kubectl apply -f /root/k8s/deployment.yml"
        }
    }

}
