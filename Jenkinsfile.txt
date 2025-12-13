pipeline {
    
	agent any
    tools {
	    maven "maven3"
	    jdk "java17"
	}
	
    stages{
        
        stage('build-app'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

	    stage('unit test'){
            steps {
                sh 'mvn test'
            }
        }
		
        stage ('checkstyle code analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('code analysis with sonarqube') {
          
		  environment {
             scannerHome = tool 'sonar-scanner-6'
          }
          steps {
            withSonarQubeEnv('sonar-server') {
               sh '''${scannerHome}/bin/sonar-scanner \
                   -Dsonar.projectKey=java-app \
                   -Dsonar.projectName=javaapp-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml \
                   -Dsonar.organization=myreg-app'''
            }
          }
        }
    }
}
