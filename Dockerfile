FROM jenkins
MAINTAINER chrisu

USER root

RUN mkdir /var/jenkins_home/jobs && mkdir /var/jenkins_home/.ssh

#ADD ssh/* /var/jenkins_home/.ssh/
#RUN chmod 600 /var/jenkins_home/.ssh/id_rsa

RUN cd /usr/bin && \
	wget https://releases.rancher.com/cli/v0.6.4/rancher-linux-amd64-v0.6.4.tar.gz && \
	tar xvf rancher-linux-amd64-v0.6.4.tar.gz && \
	rm rancher-linux-amd64-v0.6.4.tar.gz && \
	find . -name 'rancher' | xargs cp -t /usr/bin && \
	chmod +x /usr/bin/rancher && \
	rm -R rancher-*

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

COPY jenkins/jobs /var/jenkins_home/jobs

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN sudo chown -R jenkins:jenkins /var/jenkins_home