# docker-letsencrypt

container to generate letsencrypt certs using dehydrated + lexicon

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-letsencrypt/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own image badge on microbadger.com")

## Docs
- https://github.com/lukas2511/dehydrated
- https://github.com/AnalogJ/lexicon
- https://github.com/willfarrell/docker-nginx

## Dockerfile
Use to set your own defaults or overwrite in the command
```Dockerfile
FROM willfarrell/letsencrypt:latest

COPY config /etc/dehydrated/config
```

## ENV
```
# defaults to `staging`, use `production` when ready.
LE_ENV=staging
# Only required if you plan to use dns-01 challenges (use for private services)
# CloudFlare example
PROVIDER=cloudflare
LEXICON_CLOUDFLARE_USERNAME=
LEXICON_CLOUDFLARE_TOKEN=

# Route 53 example
PROVIDER=route53
LEXICON_ROUTE53_ACCESS_KEY=
LEXICON_ROUTE53_ACCESS_SECRET=
```

## Testing
```bash
docker build -t letsencrypt .

# private
docker run \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --hook dehydrated-dns \
        --challenge dns-01 \
        --force

# public
docker run -d \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --challenge http-01 \
        --force

# reload nginx to see changes                                                                         
```

## Deploy
Note the use of `--hook dehydrated-dns`, [dehydrated-dns](https://github.com/AnalogJ/lexicon/blob/master/examples/dehydrated.default.sh) is a script wrapper to call lexicon from dehydrated.
```bash
# private
docker run \
    --volumes-from docker_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --hook dehydrated-dns \
        --challenge dns-01

# public
docker run -d \
    --volumes-from docker_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --challenge http-01
```
Also worth reading is Let's Encrypts document on certificate rate limits https://letsencrypt.org/docs/rate-limits/. In short you can generate 5 duplicate certificates per 7 days.

## Route53 Access Policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZonesByName"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/${HOSTED_ZONE_ID}"
            ]
        }
    ]
}
```

## Staging Certificate
Staging certificates are not natively trusted. If you'd like to prevent the security messages in the browser;

### Mac
1. Download [`Fake LE Intermediate X1`](https://letsencrypt.org/docs/staging-environment/).
2. Open `Applications` -> `Utilities` -> `Keychain Access`.
3. Click on `Certificates`.
4. Drag `fakeleintermediatex1.pem` into the window to add it.
5. Double click `Fake LE Intermediate X1`.
6. Window will pop open. Under the `Trust` section, set `When using this certificate` to `Always Trust`.
7. Close window. Confirm window will pop open. Enter password and click `Update Settings`.

There should now be a blue and white plus icon associated with the certificate. You may need to restart your browser before the change takes effect.

### iOS
1. Go to https://letsencrypt.org/docs/staging-environment click on `Fake LE Intermediate X1`.
2. You will be redirected to an `Install Profile` page. Click `Install`.
3. Enter device password.
4. Click `Install`, and `Install` again.
5. Click `Done`.

To view the certificate got to `Settings` -> `General` -> `Profile`.

## Android
https://www.globalsign.com/en/blog/installing-certificates-onto-android-devices/
