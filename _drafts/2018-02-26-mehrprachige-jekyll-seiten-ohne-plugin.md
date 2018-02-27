---
layout: post
title:  "Mehrsprachige Seiten mit Jekyll ohne Plugin"
date:   2018-02-25 21:00:00
excerpt: "Wie ich Mehrsprachigkeit bei meinen Github-Seiten umgesetzt habe."
image:
thumb:
tags: [github, gh-pages, jekyll, liquid, mehrsprachig, internationalisierung, i18n, lokalisierung, l10n, entwicklung]
categories: [posts, development]
comments: true
lang: de
ref: post-localized-jekyll-pages-without-plugin
---

## Einleitung

Endlich sind meine persönlichen Seiten mit neuem frischem Look basierend auf Andrew Branchichs's [Editorial theme](https://html5up.net/editorial) online. Bei der Umgestaltung war mir Mehrsprachigkeit sehr wichtig.
Auch wenn ich natürlich gerne in meiner deutschen Muttersprache poste, so wollte ich mir doch die Möglichkeit erhalten, auch englischsprachige Artikel zu verfassen bzw. optional einige Artikel ins Englische zu übersetzen.
Schon bei der vorherigen "Moon"-Theme Variante schaute ich mir dazu einige Jekyll-Plugins an, fand deren Anwendung aber zu kompliziert oder unflexibel und so baute ich mir ein eigenes Konzept ohne Einsatz von Plugins zusammen. 
Dieses Konzept wendete ich nun wieder bei der Neugestaltung meiner Seiten an und baute es aus.

## Anforderungen

1. Es soll möglich sein, Posts und normale Seiten in verschieden Sprachen (deutsch und englisch) anzubieten.
1. Der Benutzer soll über die Startseite automatisch auf den Inhalt seiner bevorzugten Sprache weitergeleitet werden.
1. Ein Wechsel der Sprache soll über Verweise möglich sein. 
1. Bei Auswahl einer Sprache sollen nur Inhalte in dieser Sprache angeboten werden, d.h. Inhalte in unterschiedlichen Sprachen sollen nicht vermischt werden.
1. Zur SEO-Optimierung sollen Inhalte in verschiedenen Sprachen auch in durch unterschiedliche URLs repräsentiert werden.
1. Zwischen Inhalten, die sowohl in der einen wie auch in einer anderen Sprache vorliegen (z.B. übersetzte Artikel), soll leicht umgeschaltet werden können. (Referenzierung untereinander)

## Startseite

OK, los geht's

Im Wurzelverzeichnis meiner Github-Seiten habe ich eine Markdown-Seite `index.md` plaziert, die Jekyll unter Zuhilfename des angegebenen Layout-Templates `home.html` zu einer `index.html` rendert. Diese `index.md` habe ich nun 2-mal kopiert und die Kopien gemäß meiner unterstützten Sprachen `de.md` und `en.md` benannt. Jekyll rendert diese Dateien nun zu `/de/index.html` und `/en/index.html`, womit ich nun die Basis für Sprachspezifische URL's habe. 
OK, näcchster Schritt! Um nun Übersetzung anbieten zu können, muss ich in den Layout-Templates erkennen können, welche Sprache auf der jeweiligen Seite aktiv ist. Das erledige ich über einen entprechenden Tag-Eintrag in den Markdown-Dateien. Ich habe mein Sprach-Tag kurz und knackig `lang` genannt.
Während die `index.md` als einzige Datei kein `lang`-Tag bekommt, werden alle anderen Markdown-Dateien damit ausgestattet, z.B.:

* de.md
```
---
layout: home
title: Hauptseite
comments: false
lang: de
--- 
```

* en.md
```
---
layout: home
title: Home
comments: false
lang: en
---
```

>Zu erwähnen sei hier, dass für eine erfolgreiche Umsetzung der Mehrsprachigkeit eine konsequente Trennung von Template und Inhalt (Markdown-Dateien) notwendig ist, da Inhalte im Gegensatz zur Gestaltung je Sprache mehrfach zu pflegen sind! 

Nun kann ich über die Auswertung des `lang`-Tags Übersetzung in den Templates einbauen. Das betrifft im wesentlichen Überschriften, Navigationseinträge, und andere wiederkehrende Informationen (abhängig vom Theme). Mein `home.html`-Layout bindet z.B. die Views (_includes) `head.html`, `banner.html` oder `sidebar.html` ein, in denen ich solche Übersetzungen vornehme.
In `head.html`, welches als erstes in alle Seiten eingebunden wird habe ich noch ein kleines Liguid-Konstrukt platziert, welches mir immer die Standardsprache in einer Variable `navlang` speichert.