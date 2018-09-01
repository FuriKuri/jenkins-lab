FROM jenkins/jenkins:2.140

USER root

RUN mkdir /var/jenkins_home/jobs && mkdir /var/jenkins_home/.ssh

#ADD ssh/* /var/jenkins_home/.ssh/
#RUN chmod 600 /var/jenkins_home/.ssh/id_rsa

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && \
    apt-get install -y \
    docker-ce \
    make \
    sudo

RUN ln -sf /usr/bin/docker.io /usr/local/bin/docker

RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

COPY --chown=jenkins:jenkins jenkins/jobs /var/jenkins_home/jobs
COPY jenkins/jobs /usr/share/jenkins/jobs
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY init.sh /usr/share/jenkins
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
