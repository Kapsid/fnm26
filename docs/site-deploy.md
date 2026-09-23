# Deploying the site

The whole site is `docs/site/`: plain HTML, one stylesheet, one webfont, some
images. **No build step, no framework.** Every link inside it is relative, so
the folder works wherever it lands, including opened straight off a disk.

## Railway (the route being taken)

Railway runs a process rather than hosting files, so the folder ships as a
tiny container: `caddy:2-alpine` plus the folder. `Dockerfile` and `Caddyfile`
live in `docs/site/` beside the pages.

### Setting up the service

1. **New Project → Deploy from GitHub repo →** `Kapsid/fnm26`.
2. **Settings → Root Directory → `docs/site`.**
   This one matters more than anything else here. Left at the repository root,
   Railway finds a Flutter app and tries to build *that*.
3. Railway sees the `Dockerfile` and uses it. There is nothing to configure:
   no build command, no start command, no environment variables.
4. **Settings → Networking → Generate Domain** gives a `*.up.railway.app`
   address to check the deploy on before any DNS is touched.

### Putting it on footballnationsmanager.com

5. **Settings → Networking → Custom Domain.** Railway then shows the exact
   `CNAME` and `TXT` records to add. **Both are required** — the TXT is the
   ownership check and the domain stays pending without it.
6. Add them at your DNS provider exactly as shown, and wait for Railway to go
   green. TLS is issued automatically.

**On the apex.** `footballnationsmanager.com` with no `www` is a CNAME at the
zone apex, which plain DNS does not allow. Providers solve it with CNAME
flattening or ALIAS/ANAME records; Cloudflare does this by default. Check what
Railway's dashboard asks for rather than assuming: if it will only give a
CNAME and your provider cannot flatten, the usual answer is to point `www` at
Railway and redirect the apex to it at the DNS provider.

### What the container does

- Listens on `$PORT`, which Railway injects.
- **Automatic HTTPS is off on purpose.** Railway terminates TLS at its edge;
  with it on, Caddy would try to get its own certificate for a hostname it is
  not reachable at, and fail.
- Serves `404.html` for anything missing.
- gzip and zstd on the way out. The stylesheet goes over the wire at 3KB.
- Caches the font and artwork for a month, the stylesheet for an hour and the
  pages for five minutes.
- `Caddyfile` and `Dockerfile` are deleted from the served directory during the
  build, so neither is reachable.

### Checking it before pushing

```
cd docs/site
docker build -t fnm-site .
docker run --rm -p 8080:8080 -e PORT=8080 fnm-site
```

Then open `http://localhost:8080`. This is the same image Railway builds.

## GitHub Pages (still wired, as a free preview)

`.github/workflows/pages.yml` publishes `docs/site` on every push to `main`,
at `https://kapsid.github.io/fnm26/`. It costs nothing and is useful for
showing somebody the site without touching the domain. Delete the workflow if
you would rather have one deployment path.

Note that with Pages published from an Actions workflow rather than a branch,
GitHub **ignores a `CNAME` file entirely** — which is why there is not one in
the folder, and why adding one would do nothing.

## Any other static host

Netlify, Cloudflare Pages, Vercel, a plain web server. Publish directory
`docs/site`, build command empty. There is nothing to build.

## If the site moves to its own repository

It is a self-contained folder, so moving it is a copy. Nothing inside the
pages needs editing. On Railway, the root directory setting then goes back to
the default.

## The only absolute URLs

The canonical links and the link-preview image point at
`https://footballnationsmanager.com`. Everything else is relative. If the
domain ever changes, grep `docs/site/*.html` for it.
