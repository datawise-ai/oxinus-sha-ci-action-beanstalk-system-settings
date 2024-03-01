FROM ubuntu:22.04

COPY .platform /beanstalk/.platform
COPY nginx.conf /beanstalk/nginx.conf

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]