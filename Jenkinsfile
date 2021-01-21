pipeline {
    agent any 
    environment {
        ANSIBLE_REPO = '/var/lib/jenkins/workspace/ansible_master'
        SCRIPTS_REPO = '/var/lib/jenkins/workspace/scripts_master'
    }
    stages {
        // deploy scripts
        stage('deploy scripts') {
            steps {
                // run ansible playbook to get them available in drake's home directory
                echo "deploying scripts to drake's home directory"
                sh 'ansible-playbook ${ANSIBLE_REPO}/deploy/deploy_scripts.yml'
            }
        }
    }
}

