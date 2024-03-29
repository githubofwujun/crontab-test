FROM centos:7.6.1810
LABEL maintainer wj <wuj@yanxintec.com>
ENV TZ "Asia/Shanghai"
ENV LANG "en_US.UTF-8"
RUN echo -e "[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.2/centos7-amd64\nenabled = 1\ngpgkey = https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck = 1"  > /etc/yum.repos.d/MariaDB.repo
RUN yum install -y wget which telnet bind-utils net-tools cronie cronie-anacron gzip MariaDB-client socat  && \
    mkdir /opt/{scripts,backup,restore,data}
# RUN echo '*/1 * * * * root  echo -e "$(date)\tcrond works" >> /tmp/cron.txt' >> /etc/crontab    
RUN wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.4/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm && \
    yum localinstall -y percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm  && \
    rm -f percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm && \
    yum clean all
# RUN echo '*/10 * * * * root  sh /opt/scripts/backup-restore.sh' >> /etc/crontab
VOLUME /opt/data /opt/restore /opt/backup /opt/scripts
CMD ["/usr/sbin/crond","-n","-p"]
