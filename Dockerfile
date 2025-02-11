FROM ruby:2.6.10-bullseye

LABEL maintainer="SUSE Containers Team <containers@suse.com>"

ENV COMPOSE=1
EXPOSE 3000


WORKDIR /srv/Portus
COPY Gemfile* ./
VOLUME ["/srv/Portus"]
 
RUN export http_proxy="http://192.168.0.108:7890" && \
    export https_proxy="http://192.168.0.108:7890" && \
    apt-get update && apt-get install -y libmariadb-dev postgresql-server-dev-all nodejs libxml2-dev libxslt1-dev git npm g++ --fix-missing && \
    apt-get remove --purge golang-go && \
    npm install -g phantomjs-prebuilt && \ 
    wget https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go1.20.5.linux-amd64.tar.gz && \
    bundle install --retry=3 && \
    gem install bundler --no-document -v 1.17.3 && \
    GOROOT="/usr/local/go" && \
    GOPATH="$HOME/go" && \
    PATH="$PATH:/usr/local/go/bin:$HOME/go/bin" && \
    go install github.com/vbatts/git-validation@latest && \
    mv /root/go/bin/git-validation /usr/local/bin && \
    go install github.com/openSUSE/portusctl@latest && \
    mv /root/go/bin/portusctl /usr/local/bin/ && \
    export http_proxy="" && \
    export https_proxy=""

# ADD . .
