# The Football Nations Manager site

Plain static files. No build step, no framework, no server-side code: what is
in this folder is exactly what goes on the host.

## Two languages, one folder

English sits at the root, because that is where the App Store listing points.
Czech sits in `cs/`, page for page:

    index.html        cs/index.html
    privacy.html      cs/privacy.html
    support.html      cs/support.html
    404.html          (one, shared, bilingual)

The stylesheet, the font and the artwork are shared, so the Czech pages reach
them with `../`. There is one `_style.css` and it is edited once.

Every page carries a small `EN / CS` control at the top that links to its own
counterpart, not to the homepage. **If you add a page, add both halves and
point each one at the other**, or the switcher will quietly drop somebody on
the wrong page.

There is deliberately no redirect by browser language. It breaks a shared
link, it overrides people who chose the other language on purpose, and it is
miserable to debug on an FTP host.

The 404 is a single bilingual page, English above Czech, and its links are
root-relative because Apache serves it at whatever URL was missed. A second
error page would need a second `ErrorDocument` in a `cs/.htaccess`, which is a
dotfile inside a subfolder on an FTP host: too easy to lose for what it buys.

## Look at it locally first

    cd docs/site
    python3 -m http.server 8000

Then open <http://localhost:8000> and <http://localhost:8000/cs/>. Every path
is relative, so the site behaves the same locally as it does on the domain.

The one thing the local server does NOT do is read `.htaccess`, so the 404
page and the caching are not exercised here. Both are worth a look once the
files are actually up.

## Putting it up

Upload the WHOLE folder to the host's web root, usually `www/` or
`public_html/`. There is nothing to install and nothing to run.

**Upload both language trees together.** The Czech pages depend on assets that
live one level up, and both trees point at each other; uploading one without
the other leaves live links to pages that are not there.

Two things that go wrong with FTP in particular:

- **`.htaccess` is a dotfile**, and most FTP clients hide dotfiles unless you
  turn that on. If the 404 page is not working, check the file arrived at all.
- **Upload the images as binary.** A client left on ASCII mode corrupts
  `.png`, `.jpg` and `.woff2`. Nearly every client defaults to automatic,
  which is correct; it is only worth checking if the logo arrives broken.

## House rules for the copy

- **No em dashes**, in either language. The app copy has this rule and the
  site follows it.
- The app never says "World Cup" in English; it is the **World Championship**,
  and in Czech the **Světový šampionát**. The app's `lib/l10n/app_cs.arb` is
  the authority for every other name the site uses, too. A site that calls a
  thing one name and the app another reads as two products.

## Still to fill in

The page ships with placeholders, each one deliberate so it is easy to grep.
The URLs are shared by both trees; the prose is per language:

- `APPSTORE_URL` and `GOOGLEPLAY_URL` in `index.html` and `cs/index.html` the
  store links. Until they are real the badges are greyed out and unclickable,
  which is on purpose.
- `LINKEDIN_URL` in `index.html` and `cs/index.html`, twice in each: the About
  button and the footer.
- The two About paragraphs in `index.html`, marked as placeholder text, **and
  the Czech pair in `cs/index.html`**, which is placeholder in the same way.
  Four paragraphs in total, and the Czech is not a translation of the English:
  write each in its own language.
- `me.jpg` a portrait, roughly 4:5, at the root. Missing, the portrait removes
  itself on both pages.
- `shots/shot-1.jpg` … `shot-5.jpg` phone screenshots, 9:19.5, at the root.
  Missing, each slide keeps a dashed frame, so the carousel still reads as a
  carousel while it is being filled.

Nothing in that list breaks the page by being absent; see the script at the
bottom of `index.html`, which `cs/index.html` carries too.
