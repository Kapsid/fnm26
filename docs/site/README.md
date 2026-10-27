# The Football Nations Manager site

Plain static files. No build step, no framework, no server-side code: what is
in this folder is exactly what goes on the host.

## Six languages, one folder

English sits at the root, because that is where the App Store listing points.
Czech, French, Spanish, German and Portuguese each sit in their own folder,
page for page:

    index.html     cs/index.html     fr/  es/  de/  pt/  (same three files)
    privacy.html   cs/privacy.html
    support.html   cs/support.html
    404.html       (one, shared, every language)

The stylesheet, the font and the artwork are shared, so the language folders
reach them with `../`. There is one `_style.css` and it is edited once.

Only English and Czech have their own artwork. `fr/`, `es/`, `de/` and `pt/`
use the ENGLISH screenshots (`../shots/`), hero pair, store badges and
`og-image.jpg`, at the owner's request, until localised shots exist. When they
do, give the folder its own `shots/`, `hero-*.jpg` and badges the way `cs/`
has them, and change the paths in that folder's `index.html`.

Every page carries a small `EN / CS / FR / ES / DE / PT` control at the top
that links to the same page in each language, not to the homepage, with the
current language lit. **If you add a page, add all six versions and point each
one at the other five**, or the switcher will quietly drop somebody on the
wrong page. It fits a 320px phone as it is; a seventh language would need the
padding in `.lang a, .lang span` looked at again.

There is deliberately no redirect by browser language. It breaks a shared
link, it overrides people who chose the other language on purpose, and it is
miserable to debug on an FTP host.

The 404 is a single page, one line per language (English first), with a home
button per language, and its links are root-relative because Apache serves it at whatever URL was missed. A second
error page would need its own `ErrorDocument` in a `.htaccess` inside each
language folder, a dotfile inside a subfolder on an FTP host: too easy to lose
for what it buys.

## Look at it locally first

    cd docs/site
    python3 -m http.server 8000

Then open <http://localhost:8000>, <http://localhost:8000/cs/>,
<http://localhost:8000/fr/> and so on. Every path
is relative, so the site behaves the same locally as it does on the domain.

The one thing the local server does NOT do is read `.htaccess`, so the 404
page and the caching are not exercised here. Both are worth a look once the
files are actually up.

## Putting it up

Upload the WHOLE folder to the host's web root, usually `www/` or
`public_html/`. There is nothing to install and nothing to run.

**Upload all six language trees together.** The language folders depend on
assets that live one level up, and every tree points at every other; uploading
one without the others leaves live links to pages that are not there.

Two things that go wrong with FTP in particular:

- **`.htaccess` is a dotfile**, and most FTP clients hide dotfiles unless you
  turn that on. If the 404 page is not working, check the file arrived at all.
- **Upload the images as binary.** A client left on ASCII mode corrupts
  `.png`, `.jpg` and `.woff2`. Nearly every client defaults to automatic,
  which is correct; it is only worth checking if the logo arrives broken.

## House rules for the copy

- **No em dashes**, in any language. The app copy has this rule and the
  site follows it.
- The app never says "World Cup"; it is the **World Championship**: Czech
  **Světový šampionát**, French **Championnat du monde**, Spanish **Campeonato
  del Mundo**, German **Weltmeisterschaft**, Portuguese **Campeonato Mundial**.
  Never "Coupe du monde", "Copa del Mundo", "Mundial" on its own, "WM-Pokal"
  or "Copa do Mundo".
- The app's `lib/l10n/app_<lang>.arb` is the authority for every other name
  the site uses, too (Illimité / Ilimitado / Unlimited / sem limites, the save
  buttons, Settings, and so on). A site that calls a thing one name and the app
  another reads as two products.
- Portuguese is **Brazilian**, because `app_pt.arb` is (celular, gols, você).
  German uses "Sie", French "vous", Spanish "tú", matching the app.
- The privacy policy is a legal text: the five translations say exactly what
  the English says. Change the English first, then every translation, and
  move the date on all six.

## The store badges

Both stores are LIVE. The hero's App Store badge links to
https://apps.apple.com/app/football-nations-manager/id6814666162 and the
Google Play badge to https://play.google.com/store/apps/details?id=com.fnm.fnm ,
in all six home pages. The greyed-out `.store-soon` /
`.stamp` CSS is no longer used by any page. The Google badge has had its built-in clear
space trimmed off, so both badges are set to the same height and genuinely
match; do not replace that file with a fresh download without trimming it
again.

The Czech page has its OWN official Czech badges, `cs/badge-appstore.svg`
("Stáhnout v App Store", from Apple's marketing toolbox) and
`cs/badge-googleplay.png` ("Rozjeďte to na Google Play", clear space trimmed
the same way). Do not point `cs/index.html` back at the English ones.

Under the badges, `.devices` shows the hub on a tablet with a phone leaning
on its corner: `hero-tablet.jpg` / `hero-phone.jpg`, one pair per language
(`cs/` has its own Czech pair).

### Search and sharing

`robots.txt`, `sitemap.xml` and a `SoftwareApplication` block of JSON-LD on
every home page, with `inLanguage` listing the six site languages. The sitemap
lists each page once per language and names all six alternates plus
`x-default` (English); every page's `<head>` carries the same seven
`hreflang` links and an `og:locale` with the other five as
`og:locale:alternate` (`pt_BR` for Portuguese). That is what tells a search
engine these are one page in six languages and not duplicates.

`og-image.jpg` and `og-image-cs.jpg` are the 1200x630 share cards. They exist
because `og:image` used to point at `icon.png`, which is 180x180, while
`twitter:card` asked for `summary_large_image`: every share of the site was
being dropped or shrunk to a thumbnail. Regenerate them if the claim line
changes; they are composed from `logo.png` and the app's own TTF.

The JSON-LD deliberately carries NO `offers` block. The price is not stated
on the page, and structured data that claims something the page does not show
is treated as a mismatch.

Two things to keep in mind whenever you edit:

- **Bump `?v=` on the stylesheet link** in every page, all 19 of them (six
  languages times three, plus the 404). `.htaccess` tells
  browsers to hold CSS for an hour, and without the bump that hour is exactly
  how long your change stays invisible. It is at `?v=15` now.
- **The language trees move together.** A new page needs all six versions,
  seven hreflang lines, a sitemap entry per language and a switcher target in
  each, and nothing here will catch a half-done set.
