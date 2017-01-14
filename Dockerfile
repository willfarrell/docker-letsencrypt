FROM library/alpine:3.5

# deps - python openssl curl sed grep mktemp
RUN apk add --no-cache --virtual .build-deps git \
    && apk add --no-cache --virtual .dehydrated-rundeps python py2-pip bash openssl curl \
    && pip install --upgrade pip \
    && pip install dns-lexicon dns-lexicon[route53] dns-lexicon[transip] \
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