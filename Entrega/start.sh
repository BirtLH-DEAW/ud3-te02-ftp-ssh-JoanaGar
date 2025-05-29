#!/bin/bash

# Iniciar servicios
service ssh start
service apache2 start
service proftpd start

# Clonar el repositorio privado si está vacío
if [ -z "$(ls -A /srv/ftp/repositorio)" ]; then
  echo "Clonando el repositorio privado..."
  GIT_SSH_COMMAND="ssh -i /root/.ssh/id_rsa" git clone git@github.com:deaw-birt/UD3-ftp_anonimo.git /srv/ftp/repositorio
else
  echo "Repositorio ya existe, no se clona."
fi

# Mantener el contenedor en ejecución
tail -f /dev/null