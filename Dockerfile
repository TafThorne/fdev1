# GNU GCC & other Libraries

FROM    gcc
LABEL \
 Description="Basic GNU gcc Debian environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
RUN apt-get -y update && \
  apt-get -y install \
    cppcheck \
    cpputest \
    lcov \
    libspdlog-dev \
    zip;\
  adduser builder -uid 1000 --disabled-password --gecos "Bob Builder,1,2,3"; \
  echo "builder:.builder" chpasswd
USER builder

