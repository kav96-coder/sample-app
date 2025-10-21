pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'dineshpardhu1'
    IMAGE = "${DOCKERHUB_USER}/sample-app"
    TAG = "build-${env.BUILD_NUMBER}"
    KUBECONFIG = "/var/lib/jenkins/.kube/config"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE:$TAG .'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                         usernameVariable: 'USER',
                                         passwordVariable: 'PASS')]) {
          sh '''
            echo "$PASS" | docker login -u "$USER" --password-stdin
            docker push $IMAGE:$TAG
            docker logout
          '''
        }
      }
    }

    stage('Deploy to EKS') {
            steps {
                sh '''
                    echo "Deploying to EKS..."

                    # Apply manifests (for first-time deployment)
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl apply -f k8s/ingress.yaml

                    # Update deployment image to latest build tag
                    kubectl set image deployment/sample-app-deployment sample-app=$IMAGE:$TAG --record

                    # Wait for rollout to complete
                    kubectl rollout status deployment/sample-app-deployment
                '''
            }
        }
    }

  post {
    success { echo "✅ Image pushed: $IMAGE:$TAG" }
    failure { echo "❌ Build failed" }
  }
}