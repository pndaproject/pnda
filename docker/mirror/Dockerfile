FROM centos:7.5.1804

ARG OS_USER=root
ARG PNDA_REPO="https://github.com/pndaproject/pnda"
ENV PNDA_BRANCH=develop

#Copy Files Into the Image
WORKDIR /home/$OS_USER
RUN yum install gettext sudo python -y
RUN curl -LOJ $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz
RUN tar -zxvf /home/$OS_USER/pnda-$PNDA_BRANCH.tar.gz -C /home/$OS_USER
RUN rm *.gz

#Alter yum.conf for slow connections
RUN echo "timeout=300" >> /etc/yum.conf && echo "minrate=1" >> /etc/yum.conf

#Create Mirror
WORKDIR /home/$OS_USER
RUN chmod 755 /home/$OS_USER/pnda-$PNDA_BRANCH/packer/scripts/mirror.sh
RUN /home/$OS_USER/pnda-$PNDA_BRANCH/packer/scripts/mirror.sh

RUN yum install httpd -y

EXPOSE 80
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
ENTRYPOINT ["/usr/sbin/apachectl","-DFOREGROUND"]
