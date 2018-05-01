# GNU GCC & other Libraries

FROM    gcc
LABEL \
 Description="Basic GNU gcc Debian environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
RUN apt-get -y update && \
  apt-get -y install \
    libspdlog-dev

