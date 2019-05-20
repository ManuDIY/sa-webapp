pipeline {
    agent any
    environment {
        JENKINS_AVATAR_URL="https://raw.githubusercontent.com/jenkinsci/jenkins/master/war/src/main/webapp/images/headshot.png"
    }
    stages {
        stage('Build') {
            steps {
                gitlabCommitStatus(name: 'Maven install'){
                    rocketSend(
                        attachments: [[
                            title: "${env.gitlabSourceRepoName}",
                            color: 'yellow',
                            text: "In-progress :arrows_counterclockwise:\nRecent Changes - \n${getChangeString(10)}",
                            thumbUrl: '',
                            messageLink: '',
                            collapsed: false,
                            authorName: "Build job ${env.BUILD_NUMBER} started",
                            authorIcon: '',
                            authorLink: '',
                            titleLink: "${env.BUILD_URL}",
                            titleLinkDownload: '',
                            imageUrl: '',
                            audioUrl: '',
                            videoUrl: ''
                        ]],
                        channel: 'sa-project',
                        message: '',
                        avatar: "${JENKINS_AVATAR_URL}",
                        failOnError: true,
                        rawMessage: true
                    )
                    sh "maven install"
                }
            }
        }
        stage('Package and Stage') {
            steps {
                gitlabCommitStatus(name: 'Docker build and Push'){
                    script {
                        docker.withRegistry('https://registry.linxlabs.com:5000', 'docker-cred'){
                                def customImage = docker.build("sa-webapp:${env.BUILD_ID}")
                                customImage.push()
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            rocketSend(
                attachments: [[
                    title: "${env.gitlabSourceRepoName}",
                    color: 'green',
                    text: "Success  :white_check_mark: \nRecent Changes - \n${getChangeString(10)}",
                    thumbUrl: '',
                    messageLink: '',
                    collapsed: false,
                    authorName: "Build job ${env.BUILD_NUMBER} completed",
                    authorIcon: '',
                    authorLink: '',
                    titleLink: "${env.BUILD_URL}",
                    titleLinkDownload: '',
                    imageUrl: '',
                    audioUrl: '',
                    videoUrl: ''
                ]],
                channel: 'sa-project',
                message: '',
                avatar: "${JENKINS_AVATAR_URL}",
                failOnError: true,
                rawMessage: true
            )
            updateGitlabCommitStatus(name: 'Pipeline', state: 'success')
        }
        failure {
            updateGitlabCommitStatus(name: 'Pipeline', state: 'failed')
            rocketSend(
                attachments: [[
                    title: "${env.gitlabSourceRepoName}",
                    color: 'red',
                    text: "Failed  :negative_squared_cross_mark: \nRecent Changes - ${getChangeString(10)}",
                    thumbUrl: '',
                    messageLink: '',
                    collapsed: false,
                    authorName: "Build job ${env.BUILD_NUMBER} failed",
                    authorIcon: '',
                    authorLink: '',
                    titleLink: "${env.BUILD_URL}",
                    titleLinkDownload: '',
                    imageUrl: '',
                    audioUrl: '',
                    videoUrl: ''
                ]],
                channel: 'sa-project',
                message: '',
                avatar: "${JENKINS_AVATAR_URL}",
                failOnError: true,
                rawMessage: true
            )
        }
    }
}
@NonCPS
def getChangeString(maxMessages) {
    MAX_MSG_LEN = 100
    COMMIT_HASH_DISPLAY_LEN = 7
    def changeString = ""

    def changeLogSets = currentBuild.changeSets


    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length && i + j < maxMessages; j++) {
            def entry = entries[j]
            truncated_msg = entry.msg.take(MAX_MSG_LEN)
            commitHash = entry.commitId.take(COMMIT_HASH_DISPLAY_LEN)
            changeString += "${commitHash}... - ${truncated_msg} [${entry.author}]\n"
        }
    }

    if (!changeString) {
        changeString = " There have not been changes since the last build."
    }
    return changeString
}
