# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

FROM public.ecr.aws/bitnami/ruby:3.0

ARG APP_DIR=/opt/app
ARG APP_USER=appuser
ARG APP_GROUP=appgroup

# Update package
RUN apt-get -y update && apt-get -y upgrade

# Install bundler
RUN gem install -N bundler:2.2.19

# Create an app user
RUN addgroup $APP_GROUP && \
    adduser --disabled-login --ingroup $APP_GROUP $APP_USER && \
    mkdir $APP_DIR && \
    chown $APP_USER:$APP_GROUP $APP_DIR

# Set user
WORKDIR ${APP_DIR}
USER $APP_USER

# install app dependencies
COPY --chown=$APP_USER:$APP_GROUP Gemfile Gemfile.lock ${APP_DIR}/
RUN bundle config set --local path vendor/bundle && bundle install

# Copy function code
COPY --chown=$APP_USER:$APP_GROUP config.ru ${APP_DIR}/
COPY --chown=$APP_USER:$APP_GROUP lib ${APP_DIR}/lib

# Listen on port 4567
EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]