pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'kbhara'
    IMAGE = "${DOCKERHUB_USER}/sample-app"
    TAG = "build-${BUILD_NUMBER}"
    KUBECONFIG = "/var/lib/jenkins/.kube/config"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "📥 Checking out source code from GitHub..."
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "🐳 Building Docker image: $IMAGE:$TAG"
        sh '''
          docker version
          docker build -t $IMAGE:$TAG -f app/Dockerfile app/
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        echo "📦 Pushing Docker image to Docker Hub..."
        withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                         usernameVariable: 'DOCKER_USER',
                                         passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE:$TAG
            docker logout
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        echo "🚀 Deploying to EKS..."
        sh '''
          echo "Using kubeconfig at $KUBECONFIG"
          kubectl config get-contexts

          # Apply manifests
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
          kubectl apply -f k8s/ingress.yaml

          # Update deployment image
          kubectl set image deployment/sample-app sample-app=$IMAGE:$TAG --record

          # Wait for rollout
          kubectl rollout status deployment/sample-app
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Build & Deployment Successful!"
      echo "✅ Docker Image: $IMAGE:$TAG"
    }
    failure {
      echo "❌ Build or Deployment Failed!"
    }
    always {
      echo "🏁 Pipeline completed."
    }
  }
}
