FROM declue/ubuntu

RUN apt-get update && apt-get dist-upgrade -y && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
    git \
    apt-transport-https \
    curl \
    init \
    openssh-server openssh-client \
 && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install Java
RUN apt-get update && apt-get install -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*

# Add Jenkins user and group
RUN groupadd -g 10000 jenkins \
    && useradd -d $HOME -u 10000 -g jenkins jenkins

# Install jenkins jnlp
ARG VERSION=2.263.1
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
    && chmod 755 /usr/share/jenkins \
    && chmod 644 /usr/share/jenkins/slave.jar
RUN mkdir -p /home/jenkins/.jenkins \
    && mkdir -p /home/jenkins/agent \
    && chown -R jenkins:jenkins /home/jenkins
VOLUME /home/jenkins/.jenkins
VOLUME /home/jenkins/agent
WORKDIR /home/jenkins

# download remoting.jar
RUN wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/main/remoting/4.6/remoting-4.6.jar -O /home/jenkins/agent.jar
RUN chown jenkins:jenkins /home/jenkins/agent.jar

