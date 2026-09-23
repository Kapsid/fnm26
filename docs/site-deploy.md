# Deploying the site

The whole site is `docs/site/`: plain HTML, one stylesheet, one webfont, some
images. **No build step, no framework, no server.** Every link inside it is
relative, so the folder works wherever you put it, including opened straight
off a disk.

That means "deploy" is always the same job: get this folder to a host, then
point the domain at that host.

## Option A — GitHub Pages (what the workflow already does)

`.github/workflows/pages.yml` uploads `docs/site` on every push to `main`.

1. **Settings → Pages → Source: GitHub Actions**, once.
2. It goes live at `https://kapsid.github.io/fnm26/`.

### Putting it on footballnationsmanager.com

3. **Settings → Pages → Custom domain** → `footballnationsmanager.com` → Save.
   Do NOT add a `CNAME` file to the repo: when Pages is published from an
   Actions workflow rather than a branch, GitHub ignores that file entirely.
   The setting is the only thing that counts.

4. At your DNS provider, for the apex domain:

   | Type | Name | Value |
   |------|------|-------|
   | A    | @    | 185.199.108.153 |
   | A    | @    | 185.199.109.153 |
   | A    | @    | 185.199.110.153 |
   | A    | @    | 185.199.111.153 |
   | AAAA | @    | 2606:50c0:8000::153 |
   | AAAA | @    | 2606:50c0:8001::153 |
   | AAAA | @    | 2606:50c0:8002::153 |
   | AAAA | @    | 2606:50c0:8003::153 |
   | CNAME | www | kapsid.github.io |

   Note the CNAME value has **no repository name** on it.

5. Wait for the DNS check to go green, then tick **Enforce HTTPS**. The
   certificate is issued automatically and can take up to an hour.

## Option B — any other static host

Netlify, Cloudflare Pages, Vercel, or a plain web server. Point it at
`docs/site` as the publish directory and leave the build command empty. There
is nothing to build. Then set the domain in that host's dashboard.

Cloudflare Pages is worth a look if the domain is already on Cloudflare DNS,
because the domain setup is then two clicks and no records to copy.

## If the site ever moves to its own repository

It is a self-contained folder, so moving it is a copy. Take `docs/site`, put
it at the root of the new repo, and carry `.github/workflows/pages.yml` with
it, changing `path: docs/site` to `path: .`. Nothing inside the pages needs
editing.

## After the domain is live

The canonical URLs and the link-preview image in the three pages already point
at `https://footballnationsmanager.com`. If the domain ever changes, those are
the only absolute URLs in the site; everything else is relative. Grep for
`footballnationsmanager.com` in `docs/site/*.html` to find them.
