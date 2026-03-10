FROM ubuntu:22.04

RUN apt update && apt install -y apache2 php libapache2-mod-php

COPY ./bambi /var/www/html/bambi
COPY ./resources/local.txt /home/ctf/local.txt
COPY ./resources/wordlist.txt /home/ctf/wordlist.txt

RUN mkdir -p /home/ctf && \
    chmod 600 /home/ctf/local.txt && \
    chown -R www-data:www-data /var/www/html/bambi /home/ctf/local.txt

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]