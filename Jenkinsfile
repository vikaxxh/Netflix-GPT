pipeline {
    agent any
    
    environment {
        // Find out which environment is currently active
        // This is a simplified logic. In a real scenario, this state could be stored in a DB or Consul.
        ACTIVE_ENV = sh(script: 'grep -q "app_blue" nginx/active.conf && echo "blue" || echo "green"', returnStdout: true).trim()
        INACTIVE_ENV = "\${ACTIVE_ENV == 'blue' ? 'green' : 'blue'}"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "Current Active Environment: \${ACTIVE_ENV}"
                echo "Deploying to Inactive Environment: \${INACTIVE_ENV}"
            }
        }

        stage('Build & Deploy to Inactive') {
            steps {
                echo "Building and starting container for \${INACTIVE_ENV}..."
                sh "./scripts/deploy_env.sh \${INACTIVE_ENV}"
            }
        }

        stage('Health Check') {
            steps {
                echo "Waiting for the new application to start..."
                sleep 5
                
                echo "Testing the inactive environment..."
                // Since Jenkins might be running outside the Docker network, we use docker exec to test from within the new container itself
                sh "docker exec app_\${INACTIVE_ENV} wget -qO- http://localhost:3000/health"
            }
        }

        stage('Switch Traffic') {
            steps {
                echo "Traffic is currently going to \${ACTIVE_ENV}"
                echo "Switching traffic to \${INACTIVE_ENV}..."
                
                sh "./scripts/switch_traffic.sh \${INACTIVE_ENV}"
                
                echo "Deployment Complete! Zero-downtime release successful."
            }
        }
    }
    
    post {
        always {
            echo "Pipeline Execution Finished."
        }
        success {
            echo "Successfully deployed new version to \${INACTIVE_ENV} and switched traffic."
        }
        failure {
            echo "Pipeline failed. Traffic remains on \${ACTIVE_ENV}."
        }
    }
}
