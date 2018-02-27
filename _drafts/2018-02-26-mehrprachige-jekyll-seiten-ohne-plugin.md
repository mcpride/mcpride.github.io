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

Endlich sind meine persönlichen Seiten mit neuem frischem Look basierend auf Andrew Branchichs's [Editorial theme](https://html5up.net/editorial) online. 

Bei der Umgestaltung war mir Mehrsprachigkeit sehr wichtig.
Auch wenn ich natürlich gerne in meiner deutschen Muttersprache poste, so wollte ich mir doch die Möglichkeit erhalten, auch englischsprachige Artikel zu verfassen bzw. optional einige Artikel ins Englische zu übersetzen.
Schon bei der vorherigen "Moon"-Theme Variante schaute ich mir dazu einige Jekyll-Plugins an, fand deren Anwendung aber zu kompliziert oder unflexibel und so baute ich mir ein eigenes Konzept ohne Einsatz von Plugins zusammen. 
Dieses Konzept wendete ich nun wieder bei der Neugestaltung meiner Seiten an und baute es aus.

## Anforderungen

Folgende Requirements habe ich für die Mehrsprachigkeit aufgestellt:

1. Es soll möglich sein, Posts und normale Seiten in verschieden Sprachen (deutsch und englisch) anzubieten.
1. Der Benutzer soll über die Startseite automatisch auf den Inhalt seiner bevorzugten Sprache weitergeleitet werden.
1. Ein Wechsel der Sprache soll über Verweise möglich sein. 
1. Bei Auswahl einer Sprache sollen nur Inhalte in dieser Sprache angeboten werden, d.h. Inhalte in unterschiedlichen Sprachen sollen nicht vermischt werden.
1. Zur SEO-Optimierung sollen Inhalte in verschiedenen Sprachen auch durch unterschiedliche URLs repräsentiert werden.
1. Zwischen Inhalten, die sowohl in der einen als auch in einer anderen Sprache vorliegen (z.B. übersetzte Artikel), soll leicht umgeschaltet werden können (Referenzierung untereinander).

## Startseite

Los geht's!

Im Wurzelverzeichnis meiner Github-Seiten habe ich eine Markdown-Seite `index.md` plaziert, die Jekyll unter Zuhilfenahme des angegebenen Layout-Templates `home.html` zu einer `index.html` rendert. Diese `index.md` habe ich nun 2-mal kopiert und die Kopien gemäß meiner unterstützten Sprachen `de.md` und `en.md` benannt. Jekyll rendert diese Dateien nun zu `/de/index.html` und `/en/index.html`, womit ich nun die Basis für sprachspezifische URL's habe. 

OK, nächster Schritt! 

Um nun Übersetzung anbieten zu können, muss ich in den Layout-Templates erkennen können, welche Sprache auf der jeweiligen Seite aktiv ist. Das erledige ich über einen entprechenden Tag-Eintrag in den Markdown-Dateien. Ich habe mein Sprach-Tag kurz und knackig `lang` genannt.
Während die `index.md` als einzige Datei kein `lang`-Tag bekommt, werden alle anderen Markdown-Dateien damit ausgestattet, z.B.:

* de.md

```
---
layout: home
title: Hauptseite
lang: de
--- 
```

* en.md

```
---
layout: home
title: Home
lang: en
---
```

>Zu erwähnen sei hier, dass für eine erfolgreiche Umsetzung der Mehrsprachigkeit eine konsequente Trennung von Template und Inhalt (Markdown-Dateien) notwendig ist, da Inhalte im Gegensatz zur Gestaltung je Sprache mehrfach zu pflegen sind! 

Nun kann ich über die Auswertung des `lang`-Tags Übersetzung in den Templates einbauen. Das betrifft im wesentlichen Überschriften, Navigationseinträge, und andere wiederkehrende Informationen (abhängig vom Theme). Mein `home.html`-Layout bindet z.B. die Views (_includes) `head.html`, `banner.html` oder `sidebar.html` ein, in denen ich solche Übersetzungen vornehme.
In `head.html`, welches als erstes in alle Seiten eingebunden wird habe ich noch ein kleines Liquid-Konstrukt platziert, welches mir immer eine gültige Sprache in einer Variable `navlang` speichert und notfalls auf die in der _config.yml eingestellte Standardsprache zurückfällt, falls `page.lang` nicht gesetzt wurde (navlang - "Navigation language", weil ich die Variable ursprünglich für die Navigations-Verweise eingeführt hatte).

* head.html

```
{{ "{% if page.lang " }}%}
	{{ "{% assign navlang = page.lang " }}%}
{{ "{% else " }}%}
	{{ "{% assign navlang = site.locale " }}%}
{{ "{% endif " }}%}
```
Somit habe ich auch für die `index.md`, bei der das `lang`-Tag nicht gesetzt ist, eine gültige Spracheinstellung und kann den Umstand, dass ich hier `lang` nicht gesetzt habe geschickt für die Erfüllung einer weiteren Anforderung nutzen - die automatische Weiterleitung auf den Inhalt mit der vom Benutzer bevorzugten Sprache. Dazu habe ich in das `home.html`-Template folgendes eingebaut:

```
{{ "{% unless page.lang " }}%}
<script type="text/javascript">
    $( document ).ready(function(){
        var userLang = navigator.language || navigator.userLanguage;
        if ((userLang == "de") || (userLang == "de-DE")) {
            window.location.href = "{{ "{{ site.url " }}}}/de/"
        }
        else {
            window.location.href = "{{ "{{ site.url " }}}}/en/"
        }
    });
</script>
{{ "{% endunless " }}%}
```
Wenn also `page.lang` nicht vorhanden ist, wird ein Weiterleitungsskript eingebettet, welches für
deutschsprachige Benutzer auf die deutschen Seiten, für alle anderen auf die englischsprachige Repräsentation weiterleitet. 

>Zu beachten ist dabei, dass einige Browser einen 2-stelligen, anderen jedoch den vollständigen Language-ISO-Code zurückgeben!

## Übersetzungen

Für Strings in einzelnen Sprachen habe ich mir eine Yaml-Datei namens `messages.yml` im `_data`-Unterverzeichnis erstellt. Darin werden alle zu lokalisierenden Strings - gegliedert nach Sprache - eingetragen:

```
locales:
  # English translation
  # -------------------
  en: &DEFAULT_EN
    about: "About"
    site_description: "My personal pages."
    btn_more: "More..."
    posts: "Blog"
    pages: "Pages"
    projects: "Projects"
    tags: "Tags"
    home: "Home"
    languages: "Languages"
    lang_name: "English"
    post_title: "Read this post in English..."
    page_title: "Read this page in English..."

  en_US:
    <<: *DEFAULT_EN     # use English translation for en_US
  en_UK:
    <<: *DEFAULT_EN     # use English translation for en_UK

  # German translation
  # -------------------
  de: &DEFAULT_DE
    <<: *DEFAULT_EN     # load English values as default
    about: "&Uuml;ber"
    site_description: "Meine pers&ouml;nlichen Seiten."
    btn_more: "Mehr..."
    posts: "Blog"
    pages: "Seiten"
    projects: "Projekte"
    home: "Startseite"
    languages: "Sprachen"
    lang_name: "Deutsch"
    post_title: "Diesen Artikel auf Deutsch lesen..."
    page_title: "Diese Seite auf Deutsch lesen..."
  de_DE:
    <<: *DEFAULT_DE     # use German translation for de_DE
```

In den Templates kann ich dann wie im nachfolgenden Beispiel auf die lokalisierten Strings zugreifen:

```
{{ "{{ site.data.messages.locales[navlang].home " }}}}
```

Dieser Eintrag gibt für die englisch Repräsentation `Home` und für die deutsche `Startseite` zurück.

Mit dieser Vorgehensweise folge ich der Idee von [Tuan Anh](https://tuananh.org/2014/08/13/localization-with-jekyll/)'s Blogeintrag.


## Weitere Inhalte

Um in der sprachlichen Abgrenzung konsistent zu bleiben, müssen neben der "Hauptseite" auch alle sonstigen darstellbaren Seiten je Sprache dupliziert werden. Hier muss man sich nun entscheiden, ob man die sprachliche der inhaltlichen Abgrenzung vorzieht oder umgekehrt. Auch wenn es in der URL konsistenter erscheint, zunächst nach Sprache zu splitten und dann erst nach Inhalt, wie z.B. `/de/about` oder `/en/tags`, so ziehe ich eine inhaltliche Clusterung - wie meist bei der Softwareentwicklung - vor, sodas z.B. `/about` nun in `/about/de` und `/about/en` gesplittet wird. Das erreiche ich, indem ich meine ursprüngliche `/about.md`-Datei in eine `/about/de.md` und eine `/about/en.md` kopiere und danach die entprechenden `lang`-Tags sowie weitere Attribute setze. Nun kann ich auch den Inhalt der jeweiligen Sprache anpassen.

Die gleiche Vorgehensweise wende ich auch bei `posts`, `tags` sowie `impressum` an.

| Vorher          | Nachher          | Template       | Gerendert                |
|-----------------|------------------|----------------|--------------------------|
| index.html      | /index.md        | home.html      | /index.html              |
|                 | /de.md           |                | /de/index.html           |
|                 | /en.md           |                | /en/index.html           |
|                 |                  |                |                          |
| about.md        | /about/de.md     | page.html      | /about/de/index.html     |
|                 | /about/en.md     |                | /about/en/index.html     |
|                 |                  |                |                          |
| posts.html      | /posts/de.md     | post-list.html | /posts/de/index.html     |
|                 | /posts/en.md     |                | /posts/en/index.html     |
|                 |                  |                |                          |
| tags.html       | /tags/de.md      | tag-list.html  | /tags/de/index.html      |
|                 | /tags/en.md      |                | /tags/en/index.html      |
|                 |                  |                |                          |
| impressum.md    | /impressum/de.md | page.html      | /impressum/de/index.html |
|                 | /impressum/en.md |                | /impressum/en/index.html |

## Navigation

## Posts

## Tags

 