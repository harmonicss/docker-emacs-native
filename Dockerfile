FROM ubuntu:latest

# We assume the git repo's cloned outside and copied in, instead of
# cloning it in here. But that works, too.
WORKDIR /opt
COPY . /opt

LABEL MAINTAINER "Mickey Petersen at mastering emacs"

# Needed for add-apt-repository, et al.
#
# If you're installing this outside Docker you may not need this.
RUN apt-get update \
        && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

# Needed for gcc-10 and the build process.
RUN add-apt-repository ppa:ubuntu-toolchain-r/ppa \
        && apt-get update -y \
        && apt-get install -y gcc-10 libgccjit0 libgccjit-10-dev

# Needed for fast JSON and the configure step
RUN apt-get install -y libjansson4 libjansson-dev git

# Shut up debconf as it'll fuss over postfix for no good reason
# otherwise. If you're doing this outside Docker, you do not need to
# do this.
ENV DEBIAN_FRONTEND=noninteractive

# Cheats' way of ensuring we get all the build deps for Emacs without
# specifying them ourselves. Enable source packages then tell apt to
# get all the deps for whatever Emacs version Ubuntu supports by
# default.
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get build-dep -y emacs

# Needed for compiling libgccjit or we'll get cryptic error messages
# about failing smoke tests.
ENV CC="gcc-10"


# Configure and run
RUN cd emacs && ./autogen.sh \
        && ./configure --with-native-compilation --with-mailutils

ENV JOBS=2
RUN cd emacs && make -j ${JOBS} && make install

#ENTRYPOINT ["emacs"]
CMD ["bash"]
