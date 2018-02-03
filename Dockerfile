FROM alpine:3.7

ARG TRANSMISSION_VERSION
ARG IMAGE_VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Pierre GINDRAUD <pgindraud@gmail.com>" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="Web application Transmission in docker" \
      org.label-schema.description="This image contains the Bittorent Transmission web application" \
      org.label-schema.url="https://github.com/Turgon37/docker-transmission" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/Turgon37/docker-transmission" \
      org.label-schema.vendor="Pierre GINDRAUD" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.schema-version="1.0" \
      application.transmission.version="${TRANSMISSION_VERSION}" \
      image.version="${IMAGE_VERSION}"

ENV SMTP_PORT=25 \
    SMTP_STARTTLS=no \
    SMTP_SSL=no
    #SMTP_USERNAME=SASL_USERNAME \
    #SMTP_PASSWORD=SASL_PASSWORD \
    #SMTP_SERVER=

# Install dependencies
RUN apk --no-cache add \
      jq \
      ssmtp \
      transmission-daemon=$TRANSMISSION_VERSION

# Create the working filetree
RUN mkdir -p \
      /config \
      /downloads/complete \
      /downloads/incomplete \
      /watch && \
    chown transmission:transmission \
      /config \
      /downloads \
      /downloads/complete \
      /downloads/incomplete \
      /watch && \
    chgrp transmission /etc/ssmtp /etc/ssmtp/ssmtp.conf && \
    chmod g+w /etc/ssmtp /etc/ssmtp/ssmtp.conf

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9091/tcp 51413
VOLUME ["/config", "/downloads", "/watch"]
WORKDIR /downloads

USER transmission:transmission
CMD ["/start.sh"]
