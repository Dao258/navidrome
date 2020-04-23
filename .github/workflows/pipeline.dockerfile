#####################################################
### Copy platform specific binary
FROM bash as copy-binary
ARG TARGETPLATFORM

RUN echo "Target Platform = ${TARGETPLATFORM}"

COPY dist .
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ];  then cp navidrome_linux_musl_amd64_linux_amd64/navidrome /navidrome; fi
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ];  then cp navidrome_linux_arm64_linux_arm64/navidrome /navidrome; fi
RUN if [ "$TARGETPLATFORM" = "linux/arm/v6" ]; then cp navidrome_linux_arm_linux_arm_6/navidrome /navidrome; fi
RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then cp navidrome_linux_arm_linux_arm_7/navidrome /navidrome; fi


#####################################################
### Build Final Image
FROM alpine as release
LABEL maintainer="deluan@navidrome.org"

# Install ffmpeg and output build config
RUN apk add --no-cache ffmpeg
RUN ffmpeg -buildconf

COPY --from=copy-binary /navidrome /app/
RUN chmod +x /app/navidrome

VOLUME ["/data", "/music"]
ENV ND_MUSICFOLDER /music
ENV ND_DATAFOLDER /data
ENV ND_SCANINTERVAL 1m
ENV ND_TRANSCODINGCACHESIZE 100MB
ENV ND_SESSIONTIMEOUT 30m
ENV ND_LOGLEVEL info
ENV ND_PORT 4533

EXPOSE ${ND_PORT}
HEALTHCHECK CMD wget -O- http://localhost:${ND_PORT}/ping || exit 1
WORKDIR /app

ENTRYPOINT ["/app/navidrome"]