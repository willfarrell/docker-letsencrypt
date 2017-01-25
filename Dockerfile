FROM library/alpine:3.5

# Credit: @frol for python3 - https://github.com/frol/docker-alpine-python3/blob/master/Dockerfile

# deps - python3 openssl curl sed grep mktemp
# boto3 - AWS SDK for python
RUN apk add --no-cache --virtual .build-deps git \
    && apk add --no-cache --virtual .dehydrated-rundeps python3 bash openssl curl \
    && pip3 install --upgrade pip boto3 dns-lexicon dns-lexicon[route53] dns-lexicon[transip] \
    && rm -r /root/.cache \

    && cd /tmp \
    && git clone https://github.com/lukas2511/dehydrated.git --depth 1 \
    && chmod a+x dehydrated/dehydrated \
    && mv dehydrated/dehydrated /usr/bin/ \
    && git clone https://github.com/AnalogJ/lexicon.git --depth 1 \
    && chmod a+x lexicon/examples/dehydrated.default.sh \
    && mv lexicon/examples/dehydrated.default.sh /usr/bin/dehydrated-dns \
    && rm -rf /tmp/* \

    && apk del .build-deps

COPY config /etc/dehydrated/config

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["dehydrated","-h"]
