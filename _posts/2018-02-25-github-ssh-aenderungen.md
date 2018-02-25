---
layout: post
title:  "Github verschärft SSH-Anforderungen"
date:   2018-02-25 21:00:00
excerpt: "Github hat nach Ankündigung schwache kryptografische Standards entfernt."
image:
thumb: /assets/img/thumbs/github_logo_288x174.jpg
tags: [github, git, ssh, entwicklung]
categories: [posts, development]
comments: true
lang: de
ref: github-ssh-changes
---

Folgende als angreifbar geltende kryptografischen Standards werden seit dem 22. Frbruar 2018 nicht mehr unterstützt:

* TLSv1/ TLSv1.1- Dies gilt für alle HTTPS-Verbindungen, einschließlich Web-, API- und Git-Verbindungen zu https://github.com und https://api.github.com.
* diffie-hellman-group1-sha1 - Dies gilt für alle SSH-Verbindungen zu github.com.
* diffie-hellman-group14-sha1 - Dies gilt für alle SSH-Verbindungen zu github.com.

Wer Probleme mit der Authentifizierung bei github hat, sollte seine Git-Client-Software aktualisieren! 

siehe auch: (https://github.com/blog/2507-weak-cryptographic-standards-removed) 