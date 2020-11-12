FROM nginx

# Expose HTTP and HTTPS ports
# EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg
RUN apt-get -y install tar unzip tini redis-server cron php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip

# COPY ./.deploy/entrypoint.sh /


