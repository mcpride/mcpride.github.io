---
layout: post
title:  "Localized jekyll pages without plugin"
date:   2018-02-25 21:00:00
excerpt: "How I added localization to my personal github pages"
image: /assets/img/wide/jekyll-logo-l10n.jpg
thumb: /assets/img/thumbs/jekyll-logo-l10n.jpg
tags: [github, gh-pages, jekyll, liquid, multilanguage, internationalization, i18n, localization, l10n, development]
categories: [posts, development]
comments: true
lang: en
ref: post-localized-jekyll-pages-without-plugin
---

## Introduction

Finally my personal pages with a fresh new look based on Andrew Branchichs' s[Editorial theme](https://html5up.net/editorial) are online. 

Multi-language support was very important to me for the refactoring.
Even though I like to post in german as a native speaker, I wanted to have the opportunity to write articles in english or optionally translate some articles into english.
Already with the previous "Moon" theme variant I reviewed some Jekyll plugins for this, but found their application too complicated or inflexible and so I built up my own concept without using plugins. 
I used this concept again for the redesign of my pages and extended it.

## Requirements

I have the following requirements for multi-language support:

1. It should be possible to publish posts and normal pages in different languages (German and English).
1. The reader should be automatically forwarded to the content of his preferred language via homepage.
1. A change of language should be possible via links.
1. When selecting a language, only content in this language should be offered, i.e. content in different languages should not be mixed.
1. For SEO optimization, content in different languages should also be represented by different URLs.
1. It should be possible to easily switch between content in one language and that in another (e. g. translated articles) (referencing among each other).

## Homepage

Let's go!

In the root directory of my github pages I have placed a markdown page `index.md` which Jekyll renders to an `index.html` using the given layout template `home.html`. I have now copied this `index.md` 2 times and named the copies according to my supported languages `de.md` and `en.md`. Jekyll renders these files to `/en/index.html` and `/en/index.html`, which gives me the basis for language-specific URLs.

OK, next step!

In order to be able to provide translation, I have to be able to recognize in the layout templates which language is active on the respective page. I do this via a corresponding attribute in the header of the markdown files. I have called my language attribute short and sweet `long`.
While `index.md` is the only file that doesn't get a `long` attribute, all other markdown files are decorated with it, e.g.:

* en.md

``` markdown
---
layout: home
title: Home
lang: en
---
```

* de.md

``` markdown
---
layout: home
title: Hauptseite
lang: de
---
```

>For a successful implementation of multi-language support, a consistent separation of template and content (markdown files) is necessary, as content has to be maintained several times for each language in contrast to the design!

Now I can build translation into the templates via the evaluation of the `lang` attribute. This mainly concerns headings, navigation entries and other recurring information (depending on the theme). E.g. my `home.html` layout integrates the views (_includes) `head.html`, `banner.html` or `sidebar.html`, in which I do such translations.
In `head.html`, which is the first one to be included in all pages, I have placed a small liquid construct, which always stores a valid language id in a variable `navlang` and, if necessary, falls back to the default language set in `_config.yml` if `page.lang` was not set (navlang - "Navigation language" because I originally introduced the variable for navigation links).

* head.html

``` liquid
{% raw %}{% if page.lang %}
	{% assign navlang = page.lang %}
{% else %}
	{% assign navlang = site.locale %}
{% endif %}{% endraw %}
```

So for the `index.md`, where the `lang` attribute is not set, I have a valid language setting and can use the fact that I have not set `lang` here to fulfill another requirement - the automatic forwarding to the content with the user-preferred language. For this purpose I have included the following in the `home.html` template:

``` html
{% raw %}{% unless page.lang %}
<script type="text/javascript">
    $( document ).ready(function(){
        var userLang = navigator.language || navigator.userLanguage;
        if ((userLang == "de") || (userLang == "de-DE")) {
            window.location.href = "{{ site.url }}/de/"
        }
        else {
            window.location.href = "{{ site.url }}/en/"
        }
    });
</script>
{% endunless %}{% endraw %}
```

So if `page.lang` is not available, a forwarding script is embedded, which will be used for german-speaking users to forward to the german pages, for all others to the english-speaking representation.

>Please note that some browsers return a 2-digit code, others return the complete language ISO code!

