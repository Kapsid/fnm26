# The Football Nations Manager site

Plain static files. No build step, no framework, no server-side code: what is
in this folder is exactly what goes on the host.

## Twenty-eight languages, one folder

The site speaks every language the game ships (`lib/l10n/app_*.arb`).
English sits at the root, because that is where the App Store listing points.
The other 27 each sit in their own folder, named by the app's locale code,
page for page:

    index.html     cs/index.html     bg/ cs/ da/ de/ el/ es/ fi/ fil/ fr/ hi/ hr/ hu/ id/ it/
    privacy.html   cs/privacy.html   ja/ ko/ ms/ nb/ nl/ pl/ pt/ ro/ sv/ th/ tr/ uk/ vi/
    support.html   cs/support.html   (the same three files in each)
    404.html       (one, shared, every language)

The stylesheet, the font and the artwork are shared, so the language folders
reach them with `../`. There is one `_style.css` and it is edited once.

A language with its own screenshots holds a `shots/` folder and
`hero-phone.jpg` / `hero-tablet.jpg`, and its `index.html` reaches them as
`shots/...` and `hero-*.jpg` (relative to itself, not `../`). A language
without them uses the ENGLISH artwork (`../shots/`, `../hero-*.jpg`) with its
own captions and alt text. `shots/README.md` lists which languages have their
own set and how the sets were made (since the 28-language site, all of
them do). Only `cs/` has localised store badges;
every other language uses the English badges and `og-image.jpg`.

### The language menu

Every page carries a small pill at the top right (globe, the current
language's own name, a chevron) that opens a menu of all 28 languages, each
in its own name (Deutsch, 日本語, Ελληνικά ...), ordered by that name: Latin
script first, then Greek, Cyrillic, Devanagari, Thai, Hangul and Japanese.
The names are the app's own endonyms (`settings_screen.dart`). Every entry
links to the SAME page in that language, not to the homepage, and the current
one is lit and not a link.

It is a plain `<details>`/`<summary>` with a list of links, so it opens and
works with no JavaScript at all. A one-line script after it only closes it on
an outside tap or Escape. The menu is two columns (14 rows), its width capped
at the viewport minus the gutters, so it fits a 320px phone. The block is
identical on every page except for the paths and which entry is current:
**if you add a page, add all 28 versions and give each the full menu**, or
the menu will quietly drop somebody on the wrong page.

### Scripts the font does not cover

Hanken Grotesk covers Latin, Vietnamese included, but no Greek, Cyrillic,
Devanagari, Thai, Japanese or Korean. `_style.css` sets those pages
(`:lang(el)`, `bg`, `uk`, `hi`, `th`, `ja`, `ko`) wholly in the platform's
UI face with a per-script fallback list, rather than letting the browser
stitch fallback glyphs into Hanken words. The wordmark keeps Hanken and
carries `lang="en"` (in Turkish, `text-transform: uppercase` would otherwise
print NATİONS). Tracking is switched off and heading leading raised for
Hindi, Thai, Japanese and Korean. In Japanese and Thai, which put no spaces
between words, keep each sentence of the copy on one source line: a line
break inside a sentence renders as a space.

A claim (the line under the wordmark) that is too long for one line on a
phone carries `class="claim long"`, which lets it wrap, balanced.

There is deliberately no redirect by browser language. It breaks a shared
link, it overrides people who chose the other language on purpose, and it is
miserable to debug on an FTP host.

The 404 is a single page: the English line and buttons first, then one
compact line per other language (its own name, "This page does not exist" in
that language and a home link), in the menu's order. Its links are
root-relative because Apache serves it at whatever URL was missed. A second
error page would need its own `ErrorDocument` in a `.htaccess` inside each
language folder, a dotfile inside a subfolder on an FTP host: too easy to lose
for what it buys.

## Look at it locally first

    cd docs/site
    python3 -m http.server 8000

Then open <http://localhost:8000>, <http://localhost:8000/cs/>,
<http://localhost:8000/ja/>, <http://localhost:8000/el/> and so on. Every path
is relative, so the site behaves the same locally as it does on the domain.

The one thing the local server does NOT do is read `.htaccess`, so the 404
page and the caching are not exercised here. Both are worth a look once the
files are actually up.

## Putting it up

Upload the WHOLE folder to the host's web root, usually `www/` or
`public_html/`. There is nothing to install and nothing to run.

**Upload all 28 language trees together.** The language folders depend on
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
  del Mundo**, German **Weltmeisterschaft**, Portuguese **Campeonato Mundial**, Italian
  **Campionato del mondo**, and for the other 21 exactly the app's
  `compWorldCup` string: Bulgarian Световно първенство, Danish
  Verdensmesterskabet, Greek Παγκόσμιο Πρωτάθλημα, Finnish MM-kisat, Filipino
  Kampeonato ng Mundo, Hindi विश्व चैंपियनशिप, Croatian Svjetsko prvenstvo,
  Hungarian Világbajnokság, Indonesian Kejuaraan Dunia, Japanese 世界選手権,
  Korean 세계 선수권, Malay Kejohanan Dunia, Norwegian Verdensmesterskapet, Dutch
  Wereldkampioenschap, Polish Mistrzostwa Świata, Romanian Campionatul Mondial,
  Swedish Världsmästerskapet, Thai ชิงแชมป์โลก, Turkish Dünya Şampiyonası,
  Ukrainian Чемпіонат світу, Vietnamese Giải vô địch thế giới (inflected as the
  grammar needs).
  Never "Coupe du monde", "Copa del Mundo", "Mundial" on its own, "WM-Pokal"
  "Copa do Mundo", "Coppa del Mondo" or "Mondiali", and never the local
  "cup" word either (ワールドカップ, 월드컵, Puchar Świata, Piala Dunia,
  ฟุตบอลโลก, Dünya Kupası, Кубок світу ...).
- The app's `lib/l10n/app_<lang>.arb` is the authority for every other name
  the site uses, too (Illimité / Ilimitado / Unlimited / sem limites, the save
  buttons, Settings, and so on). A site that calls a thing one name and the app
  another reads as two products.
- Portuguese is **Brazilian**, because `app_pt.arb` is (celular, gols, você).
  German uses "Sie", French "vous", Spanish and Italian "tú"/"tu", matching the app.
  The register of the 21 newer languages follows their ARB too: informal
  ("you" as ti/du/sinä/te/ty/sen...) in bg, da, el, fi, fil, hr, hu, nb, nl, pl,
  sv, tr, uk, vi; formal in hi (आप), id (Anda) and ro (dumneavoastră); polite
  neutral in ja, ko, ms and th. "Unlimited" stays "Unlimited" except where the
  app translates it (el Απεριόριστο, hi अनलिमिटेड, ja 無制限版, ko 무제한, ms Tanpa Had).
- The privacy policy is a legal text: the 27 translations say exactly what
  the English says. Change the English first, then every translation, and
  move the date on all 28.

## The store badges

Both stores are LIVE. The hero's App Store badge links to
https://apps.apple.com/app/football-nations-manager/id6814666162 and the
Google Play badge to https://play.google.com/store/apps/details?id=com.fnm.fnm ,
in all 28 home pages. The greyed-out `.store-soon` /
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
that has its own artwork, the English pair otherwise.

### Search and sharing

`robots.txt`, `sitemap.xml` and a `SoftwareApplication` block of JSON-LD on
every home page, with `inLanguage` listing the 28 site languages. The sitemap
(84 URLs) lists each page once per language and names all 28 alternates plus
`x-default` (English); every page's `<head>` carries the same 29
`hreflang` links and an `og:locale` with the other 27 as
`og:locale:alternate` (`pt_BR`, `nb_NO`, `fil_PH`, `el_GR`, `ko_KR`, `ja_JP`,
`hi_IN`, `ms_MY`, `uk_UA`, `vi_VN`, `sv_SE`, `da_DK` and so on). That is what
tells a search engine these are one page in 28 languages and not duplicates.

`og-image.jpg` and `og-image-cs.jpg` are the 1200x630 share cards. They exist
because `og:image` used to point at `icon.png`, which is 180x180, while
`twitter:card` asked for `summary_large_image`: every share of the site was
being dropped or shrunk to a thumbnail. Regenerate them if the claim line
changes; they are composed from `logo.png` and the app's own TTF.

The JSON-LD deliberately carries NO `offers` block. The price is not stated
on the page, and structured data that claims something the page does not show
is treated as a mismatch.

Two things to keep in mind whenever you edit:

- **Bump `?v=` on the stylesheet link** in every page, all 85 of them (28
  languages times three, plus the 404). `.htaccess` tells
  browsers to hold CSS for an hour, and without the bump that hour is exactly
  how long your change stays invisible. It is at `?v=18` now.
- **The language trees move together.** A new page needs all 28 versions,
  29 hreflang lines, a sitemap entry per language and a menu entry in
  each, and nothing here will catch a half-done set.
