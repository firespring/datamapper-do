FROM 435196416497.dkr.ecr.us-east-1.amazonaws.com/firespring/base:bullseye-ruby27

RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#
RUN gem install rake-compiler

