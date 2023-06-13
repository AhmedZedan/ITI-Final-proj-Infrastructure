FROM ubuntu:22.04

USER root

RUN mkdir -p /var/jenkins_home /home/jenkins

RUN adduser jenkins; echo "jenkins:123456" | chpasswd

RUN chown -R jenkins:jenkins /var/jenkins_home \
    && chown -R jenkins:jenkins /home/jenkins

WORKDIR /home/jenkins


RUN apt-get update && apt-get dist-upgrade -y && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    git \
    apt-transport-https \
    curl \
    init \
    openssh-server openssh-client \
    docker.io \
    vim \
    && rm -rf /var/lib/apt/lists/*

#install kubectl
RUN apt update && apt-get install gnupg gnupg1 gnupg2 -y
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list 
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl


# Install Java
RUN apt-get update && apt-get install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install gettext -y

RUN service ssh start

EXPOSE 22


ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]