FROM node:10-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG CHINACHU_VERSION=c3dd9a05bc97a414d8aac0e14c9ddcc1cc39d2cd
ARG USER_NAME=user
ARG CHINACHU_DIR=/usr/local/chinachu

RUN apt-get update && \
    apt-get install -y \
        git \
        ca-certificates \
        gosu

RUN useradd -m "${USER_NAME}" && \
    usermod -u 1000 -o "${USER_NAME}" && \
    groupmod -g 1000 -o "${USER_NAME}"

RUN mkdir -p "${CHINACHU_DIR}" && \
    chown -R "${USER_NAME}:${USER_NAME}" "${CHINACHU_DIR}" && \
    gosu "${USER_NAME}" git clone https://github.com/Chinachu/Chinachu.git "${CHINACHU_DIR}" && \
    cd "${CHINACHU_DIR}" && \
    gosu "${USER_NAME}" git checkout "${CHINACHU_VERSION}"

RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        python3 \
        build-essential

RUN cd "${CHINACHU_DIR}" && \
    echo 2 | gosu "${USER_NAME}" ./chinachu installer && \
    echo 4 | gosu "${USER_NAME}" ./chinachu installer && \
    echo 5 | gosu "${USER_NAME}" ./chinachu installer

RUN cd "${CHINACHU_DIR}" && \
    gosu "${USER_NAME}" ./chinachu service operator initscript > chinachu-operator.sh && \
    chmod a+x chinachu-operator.sh && \
    gosu "${USER_NAME}" ./chinachu service wui initscript > chinachu-wui.sh && \
    chmod a+x chinachu-wui.sh

RUN apt-get update && \
    apt-get install -y \
        procps

WORKDIR "${CHINACHU_DIR}"

ADD ./docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
