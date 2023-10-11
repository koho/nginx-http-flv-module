FROM nginx:mainline AS build

COPY . /tmp/nginx-http-flv-module

RUN apt update && apt install wget -y

RUN NGINX_VERSION=`nginx -v 2>&1 | cut -d '/' -f 2` \
  && cd /tmp \
  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O nginx-${NGINX_VERSION}.tar.gz \
  && apt install build-essential libpcre3-dev libssl-dev zlib1g-dev libgd-dev -y \
  && tar zxf nginx-${NGINX_VERSION}.tar.gz \
  && cd nginx-${NGINX_VERSION}  \
  && sed -i 's/\r$//' ../nginx-http-flv-module/config \
  && CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^configure arguments: //p') \
  && sh -c "./configure --with-compat ${CONFARGS} --add-dynamic-module=../nginx-http-flv-module" \
  && make modules

RUN ls /tmp/nginx-${NGINX_VERSION}/objs/