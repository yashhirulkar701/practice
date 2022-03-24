FROM centos:latest
MAINTAINER yashhirulkar701@gmail.com
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum install -y httpd \
zip \
unzip 
ADD https://www.free-css.com/assets/files/free-css-templates/download/page276/jon.zip  /var/www/html
WORKDIR  /var/www/html
RUN unzip jon.zip
RUN cp -rvf jon/* .
RUN rm -rf jon jon.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
