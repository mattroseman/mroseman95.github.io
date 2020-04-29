FROM ruby:latest
ENV LANG C.UTF-8

WORKDIR /usr/src/app

# # Install yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# 
# RUN apt-get update && \
#     apt-get install -y nodejs \ #                        yarn \
#                        vim \
#                        --no-install-recommends && \
#     rm -rf /var/lib/apt/lists/*

ADD ./Gemfile ./Gemfile
ADD ./Gemfile.lock ./Gemfile.lock
RUN bundle install

COPY . .

CMD ["bundle", "exec", "jekyll", "serve", "--config", "_config.yml,_config-dev.yml", "-H", "0.0.0.0", "--drafts"]
