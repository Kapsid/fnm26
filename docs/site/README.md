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

## When the app ships

Nothing on the page is a placeholder any more. One thing is WAITING, and it
is the launch:

The hero carries a stamped plate, "Coming in October" / "Vychází v říjnu",
where the store badges used to be, because a dead App Store link looks worse
than an honest date. On release day, in BOTH `index.html` and
`cs/index.html`, swap the `<div class="soon">` block back for the badge
markup and fill in the two URLs. The artwork is still here,
`badge-appstore.svg` and `badge-googleplay.png`, and so are the `.stores`,
`.b-apple` and `.b-google` rules in `_style.css`, all of them unused until
then. The Google badge has had its built-in clear space trimmed off, so both
badges are set to the same height and genuinely match; do not replace that
file with a fresh download without trimming it again.

Two things to keep in mind whenever you edit:

- **Bump `?v=` on the stylesheet link** in all seven pages. `.htaccess` tells
  browsers to hold CSS for an hour, and without the bump that hour is exactly
  how long your change stays invisible. It is at `?v=7` now.
- **The two language trees move together.** A new page needs both halves, two
  hreflang lines and a switcher target, and nothing here will catch a
  half-done pair.
