node {
    def is_mainline = ["develop", "master"].contains(env.BRANCH_NAME)

    List environment = [
        "PATH=$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH",
        "LANG=en_US.UTF-8",
        "LANGUAGE=en_US.UTF-8",
        "LC_ALL=en_US.UTF-8",
        "FL_SLACK_CHANNEL=#template-test"
    ]
    
    List credentials = [
        string(credentialsId: 'crashlytics-api-key', variable: 'CRASHLYTICS_API_KEY'),
        string(credentialsId: 'crashlytics-build-secret', variable: 'CRASHLYTICS_BUILD_SECRET'),
        string(credentialsId: 'dev-slack-url', variable: 'SLACK_URL'),
        string(credentialsId: 'danger-github-token', variable: 'DANGER_GITHUB_API_TOKEN')
    ]

    // Clean workspace before doing anything
    deleteDir()

    // Common setup and checkout operations.
    stage('Setup') {
        
        checkout scm
        
        withEnv(environment) {
            ansiColor('xterm') {
                sh 'bundle install'
                sh 'bundle exec fastlane update_fastlane'
            }
        }
    }
    
    stage('Pre-Build Danger') {
        withEnv(environment) {
            withCredentials(credentials) {
                ansiColor('xterm') {
                    sh 'bundle exec danger --dangerfile=PreBuildDangerfile --danger_id=pre-build'
                }
            }
        }
    }
    
    stage('Carthage') {
        withEnv(environment) {
            ansiColor('xterm') {
                sh 'bundle exec fastlane carthage_bootstrap'
            }
        }
    }
    
    if (is_mainline) {
        // Create Archive and Upload *only* if we aren't in a PR.
        stage('Create Archive') {
            withEnv(environment) {
                ansiColor('xterm') {
                    sh 'bundle exec fastlane create_archive'
                }
            }
        }

        stage('Upload') {
            withEnv(environment) {
                withCredentials(credentials) {
                      parallel(crashlytics: {
                                   ansiColor('xterm') {
                                       sh 'bundle exec fastlane upload_crashlytics'
                                   }
                               },
                               testflight: {
                                   ansiColor('xterm') {
                                       sh 'bundle exec fastlane upload_testflight'
                                   }
                               })
                }
            }
        }
        
        stage('Build Artifacts') {
            withEnv(environment) {
                archiveArtifacts artifacts: 'output/*.ipa,output/*.zip', onlyIfSuccessful: true
            }
        }
    } else {
        // Run the tests *only* if we are building on a PR.
        stage('Tests + Danger') {
            withEnv(environment) {
                withCredentials(credentials) {
                    try {
                        ansiColor('xterm') {
                            sh 'bundle exec fastlane test'
                            sh 'bundle exec jazzy'
                        }
                    } finally {
                        
                        try {
                            junit 'output/*.junit'
                        } finally {
                            ansiColor('xterm') {
                                sh 'bundle exec danger --danger_id=post-build'
                            }
                        }
                        
                        try {
                            publishHTML (target: [
                              allowMissing: false,
                              alwaysLinkToLastBuild: false,
                              keepAll: true,
                              reportDir: 'output/slather',
                              reportFiles: 'index.html',
                              reportName: "Code Coverage"
                            ])
                            publishHTML (target: [
                              allowMissing: false,
                              alwaysLinkToLastBuild: false,
                              keepAll: true,
                              reportDir: 'Documentation',
                              reportFiles: 'index.html',
                              reportName: "Documentation"
                            ])
                        } finally { }
                    }
                }
            }
        }
    }
}
