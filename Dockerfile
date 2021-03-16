FROM mcr.microsoft.com/dotnet/core/sdk:latest
LABEL maintainer="oizone@oizone.net"

ARG GH_RUNNER_VERSION="2.274.2"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV ANSIBLE_HOST_KEY_CHECKING=False
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=yes

RUN apt-get update
RUN apt-get install -y --no-install-recommends python3 
RUN apt-get install -y --no-install-recommends unzip
RUN apt-get install -y --no-install-recommends xorriso

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY token.sh /
RUN chmod +x /token.sh

ENTRYPOINT ["/entrypoint.sh"]
