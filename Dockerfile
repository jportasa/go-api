FROM scratch
MAINTAINER Joan Porta <jportasa@gmail.com>

COPY api /

EXPOSE 3001
ENTRYPOINT ["/api"]