# Docker file for python simple webservice build

FROM ubuntu:17.04
MAINTAINER Shohei Mukai

# Change apt source to ustc mirrors
Run sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn\/ubuntu-old-releases/g' /etc/apt/sources.list
Run sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn\/ubuntu-old-releases/g' /etc/apt/sources.list
Run apt-get update
# Http
Run apt-get -y install apache2
# Python2.7
Run apt-get -y install python2.7
Run apt-get -y install libmysqlclient-dev
RUN apt-get -y install vim
RUN apt-get -y install python-pip
RUN pip install MySQL-python
# Python3.6
RUN apt-get -y install python3.6
Run apt-get -y install wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py
RUN apt-get -y install python3.6-dev
RUN python3.6 -m pip install mysqlclient
# Http settings
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

RUN mkdir -p /production/www/cgi-bin
RUN mkdir -p /production/www/lib
COPY cgi-bin /production/www/cgi-bin
COPY lib /production/www/lib
COPY apache2 /etc/apache2
RUN ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND"]
