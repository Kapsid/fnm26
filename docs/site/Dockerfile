# The site is static, so the image is a web server and the folder. Nothing is
# built, because there is nothing to build.
FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY . /srv

# The build context has to contain these two for the COPY above to work, so
# they land in /srv as well. Serving your own server config is not a habit
# worth having, so they come straight back out.
RUN rm -f /srv/Caddyfile /srv/Dockerfile /srv/.dockerignore \
 && caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

EXPOSE 8080
