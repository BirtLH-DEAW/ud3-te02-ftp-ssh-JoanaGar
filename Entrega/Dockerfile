FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Actualizaciones e instalaciones básicas
RUN apt-get update && apt-get install -y \
    nano apache2 \
    git openssh-client openssh-server \
    proftpd-basic openssl && \
    rm -rf /var/lib/apt/lists/*

# 2. Crear directorios para los sitios web
RUN mkdir -p /var/www/html/sitioprimero /var/www/html/sitiosegundo

# 3. Copiar archivos web
COPY apache/indexPrimero.html /var/www/html/sitioprimero/index.html
COPY apache/indexSegundo.html /var/www/html/sitiosegundo/index.html

# 4. Crear usuarios
RUN useradd -d /var/www/html/sitioprimero -s /usr/sbin/nologin joagarcia1 && \
    echo "joagarcia1:deaw" | chpasswd && \
    chown -R joagarcia1:joagarcia1 /var/www/html/sitioprimero

RUN useradd -d /var/www/html/sitiosegundo -s /bin/bash joagarcia2 && \
    echo "joagarcia2:deaw" | chpasswd && \
    chown -R joagarcia2:joagarcia2 /var/www/html/sitiosegundo

# 5. Añadir nologin a /etc/shells
RUN echo "/usr/sbin/nologin" >> /etc/shells

# 6. Configurar Apache
COPY apache/sitioPrimero.conf /etc/apache2/sites-available/
COPY apache/sitioSegundo.conf /etc/apache2/sites-available/
COPY apache/sitioPrimero.cer /etc/ssl/certs/sitioPrimero.cer
COPY apache/sitioPrimero.key /etc/ssl/private/sitioPrimero.key
RUN a2ensite sitioPrimero.conf && \
    a2ensite sitioSegundo.conf && \
    a2enmod ssl && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 7. Configurar SSH (puerto 2222)
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    mkdir /var/run/sshd

# 8. Configurar ProFTPD con TLS
COPY ftp/proftpd.conf /etc/proftpd/proftpd.conf
COPY ftp/tls.conf /etc/proftpd/tls.conf
COPY ftp/modules.conf /etc/proftpd/modules.conf
COPY ftp/ftp.crt /etc/proftpd/ssl/ftp.crt
COPY ftp/ftp.key /etc/proftpd/ssl/ftp.key
RUN chmod 600 /etc/proftpd/ssl/ftp.key && chmod 644 /etc/proftpd/ssl/ftp.crt

# 9. Crear carpeta FTP anónimo
RUN mkdir -p /srv/ftp/repositorio && \
    chown -R ftp:nogroup /srv/ftp

# 10. Copiar clave SSH privada para GitHub
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# 11. Copiar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 12. Exponer puertos
EXPOSE 80 443 21 2222 50000-50030

# 13. Comando por defecto
CMD ["/start.sh"]