FROM ubuntu:14.04.1
MAINTAINER Ken Cochrane "lichenly22@gmail.com"
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' > /etc/apt/sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y python-dev python-setuptools supervisor git-core
RUN easy_install pip
RUN pip install virtualenv
RUN pip install uwsgi
RUN virtualenv --no-site-packages /opt/ve/djdocker
ADD . /opt/apps/djdocker
ADD .docker/supervisor.conf /opt/supervisor.conf
ADD .docker/run.sh /usr/local/bin/run
RUN (cd /opt/apps/djdocker && git remote rm origin)
RUN (cd /opt/apps/djdocker && git remote add origin https://github.com/lily22/demo.git)
RUN pip install -r /opt/apps/djdocker/requirements.txt
RUN (cd /opt/apps/djdocker && /opt/ve/djdocker/bin/python manage.py migrate)
RUN (cd /opt/apps/djdocker && /opt/ve/djdocker/bin/python manage.py runserver)
EXPOSE 5000
CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
