# TODO python 3 not-supported lexicon#68
FROM library/python:2-alpine

# deps - openssl curl sed grep mktemp
RUN apk --no-cache add bash openssl curl git \
    && cd /tmp \
    && git clone https://github.com/lukas2511/dehydrated.git --depth 1 \
    && chmod a+x dehydrated/dehydrated \
    && mv dehydrated/dehydrated /usr/bin/ \
    && git clone https://github.com/AnalogJ/lexicon.git --depth 1 \
    && chmod a+x lexicon/examples/dehydrated.default.sh \
    && mv lexicon/examples/dehydrated.default.sh /usr/bin/dehydrated-dns \
    && rm -rf /tmp/* \
    && pip install dns-lexicon dns-lexicon[route53] dns-lexicon[transip] \
    && apk del git

COPY config /etc/dehydrated/config

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["dehydrated","-h"]