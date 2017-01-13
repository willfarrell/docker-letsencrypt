# docker-letsencrypt

container to generate letsencrypt certs using dehydrated + lexicon

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-letsencrypt/blob/master/Dockerfile)


## Dockerfile
Use to set your own defaults
```Dockerfile
FROM willfarrell/letsencrypt:latest

COPY config /etc/dehydrated/config
```

## ENV
```
# defaults to `staging`, use `production` when ready.
LE_ENV=staging
# Only required if you plan to use dns-01 challenges (use for private services)
PROVIDER=cloudflare
LEXICON_CLOUDFLARE_USERNAME=
LEXICON_CLOUDFLARE_TOKEN=
```

## Testing
```bash
docker build -t letsencrypt .
docker rm -f letsencrypt

# private
docker run \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --hook dehydrated-dns \
        --challenge dns-01 \
        --force

# public
docker run -d \
    --volumes-from nginx_nginx_1 \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --challenge http-01 \
        --force

# reload nginx
docker exec -it nginx_nginx_1 /etc/scripts/make_hpkp && /etc/init.d/nginx reload                                                                          
```

## Deploy
```bash
# private
docker run \
    --volumes-from nginx_nginx_1 \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --hook dehydrated-dns \
        --challenge dns-01

# public
docker run -d \
    --volumes-from nginx_nginx_1 \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --challenge http-01
```

## TODO
- [ ] Update to python 3 (not-supported lexicon#68)