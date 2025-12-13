pipeline{
    agent any
    environment{
        PROJECT_KEY="Demo-Project"
    }
    stages{
        stage('SCM'){
            steps{
                git branch: 'main', url: 'https://github.com/Amith373/SonarrQube_Jenkins.git'
            }
        }
        stage('sonar analysis'){
            steps{
                withSonarQubeEnv('SonarQube-K8s'){
                    sh """ mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=${PROJECT_KEY} \
                    -Dsonar.projectName=${PROJECT_KEY}
                    """
                }
            }
        }
        stage('Quality gate validate'){
            steps{
                timeout(time: 5, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
                  post{
                    success{
                           echo "Quality Gate Passed"
                        }
                   failure{
                           echo "Quality Gate Failed"
                     }
                }
            }
        }
    }
  
