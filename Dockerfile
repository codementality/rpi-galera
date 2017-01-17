FROM resin/rpi-raspbian:jessie

MAINTAINER "Lisa Ridley, lhridley@gmail.com"

RUN echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list.d/stretch.list \
 && echo "APT::Default-Release \"jessie\";" > /etc/apt/apt.conf.d/99-default-release \

 && apt-get update -y && apt-get upgrade -y \
 && apt-get dist-upgrade -y \
 && apt-get install -y build-essential git cmake scons rpi-update \
 && apt-get install -y libarchive-dev libevent-dev libssl-dev libboost-dev \
 && apt-get install -t stretch -y libncurses5-dev libbison-dev bison

RUN cd /tmp \
 && git clone -b 10.1 https://github.com/MariaDB/server.git --depth=1 mariadb-server-src \
 && cd mariadb-server-src \
 && cmake -DWITH_WSREP=ON -DWITH_INNODB_DISALLOW_WRITES=ON ./ \
 && make \
 && make install \

 && cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld \
 && update-rc.d mysqld defaults

