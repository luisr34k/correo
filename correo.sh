#!/bin/bash

# Umbral de espacio libre en disco (en porcentaje)
umbral=80

# Obtener el espacio libre en disco de la partición raíz
espacio_libre=$(df -h | grep '/' | awk '{ print $5 }')

# Eliminar el signo de porcentaje
espacio_libre_sin_porcentaje=${espacio_libre%\%}

# Verificar si el espacio libre es menor que el umbral
if [ $espacio_libre_sin_porcentaje -lt $umbral ]; then
  # Enviar correo electrónico de alerta
  asunto="Espacio libre en disco bajo en la partición raíz"
  cuerpo="El espacio libre en disco de la partición raíz es de solo $espacio_libre_sin_porcentaje%. Se recomienda liberar espacio en disco lo antes posible."
  correo_electronico="luislazaroaquino01@gmail.com"

  # Reemplazar con las credenciales de tu cuenta de Gmail
  usuario_smtp="luislazaroaquino01@gmail.com"
  password_smtp="0e3dec5ffe"

  # Instalar `msmtp` si es necesario (solo la primera vez)
  if ! which msmtp > /dev/null; then
    sudo apt install msmtp -y
  fi

  # Configurar `msmtp` para Gmail
  echo "from: $usuario_smtp" > ~/.msmtprc
  echo "host: smtp.gmail.com" >> ~/.msmtprc
  echo "port: 587" >> ~/.msmtprc
  echo "tls: on" >> ~/.msmtprc
  echo "auth: login" >> ~/.msmtprc
  echo "user: $usuario_smtp" >> ~/.msmtprc
  echo "password: $password_smtp" >> ~/.msmtprc

  # Enviar correo electrónico usando `msmtp`
  msmtp -c ~/.msmtprc -t $correo_electronico -s "$asunto" << EOF
$cuerpo
EOF

else
  echo "El espacio libre en disco de la partición raíz es del $espacio_libre_sin_porcentaje%. No se requiere acción en este momento."
fi
