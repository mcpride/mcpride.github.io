---
layout: post
title:  "LocalDB produktiv einsetzen"
date:   2018-01-23 09:30:00
excerpt: "Wie man MS-SQL localdb in produktiven Umgebungen einsetzen kann."
feature: /assets/img/reldata.jpg
tags: [db, datenbanken, persistenz, mssql, localdb, entwicklung]
categories: [posts, development]
comments: true
lang: de
ref: productive usage of localdb
---


<!-- MDTOC maxdepth:6 firsth1:0 numbering:1 flatten:0 bullets:0 updateOnSave:1 -->

  

<!-- /MDTOC -->

## Was ist LocalDB

LocalDB ist eine frei einsetzbare Variante des SQL-Servers von Microsoft, die sich von Leistung und vom Umfang noch unterhalb von MS-SQL-Express einordnen lässt. Ursprünglich wurde dieser Abkömmling für die Software-Entwicklung konzipiert, damit Entwickler ihre Projekte einfach testen können. LocalDB verfügt über alle wesentlichen Datenbankfunktionen des großen Bruders, der Zugriff ist jedoch nur auf die lokale Windows-Maschine begrenzt. Es existiert auch keine zentrale Hostinstanz, sondern eine solche wird auf Anforderung als Kindprozess im Benutzerkontext gestartet und nach mehreren Minuten Inaktivität auch wieder beendet, was Ressourcen schont. LocalDB wird also im Gegensatz zu MS-SQL-Compact oder SQLITE nicht "In-Process" gehostet, sodass mehrere Prozesse parallel auf die Daten zugreifen können.

## Mögliche produktive Einsatzszenarien

LocalDB könnte für alle Projekte interessant sein, die "klein anfangen", sich jedoch die Skalierungsoption bei der Persistenz vorbehalten wollen. Kleine Webprojekte oder in Komandozeilen-Programmen oder Windows-Diensten gehostete "Microservices", die eine (relationale) Speichermöglichkeit von Daten mit kleinem Fußabdruck auf das System benötigen, könnten Kanditaten für die Integration mit LocalDB sein.


## Houston, wir haben ein Problem

Normalerweise sind allerdings alle Instanzen von LocalDB privat, d.h. nur im aktuellen Benutzerkontext (gilt für Standardinstanzen, wie z.B. (localdb)\v11.0) bzw. im Kontext des Erstellers erreichbar. Dieses Szenario eignet sich in der Praxis höchstens für lokale, benutzerbezogene Desktopanwendungen oder Windowsdienste, die man in einem eigenen Benutzekonto laufen lässt. 

Für ASP.NET-Anwendungen, die in einem Applicationpool des IIS gehostet werden oder Dienste, die im Sytemprofil oder im Netzwerkdienst-Konto laufen, ist das keine ernsthafte Alternative. Selbst wenn man es schafft, unter diesen Profilen Standardinstanzen, wie "v11.0" anzusprechen und Datenbanken zu erzeugen, so sind diese doch im Prinzip unwartbar, da man für diese Konten kein Windows-Login hat.

## Die Lösung

Glücklicherweise kann man private Instanzen auch teilen. So kann ich z.B. mit folgendem Befehl meine private Standardinstanz "v11.0"s als "MySharedInstance" für andere Benutzerkonten veröffentlichen:

```
SqlLocalDB share "v11.0" "MySharedInstance"
```

>Dieser `Share`-Befehl benötigt administrative Berechtigungen! 

Das hier verwendete Tool `SqlLocalDB.exe` wird bei der Installation von LocalDB mitgeliefert und ist exemplarisch unter folgendem Pfad installiert:

 `C:\Program Files\Microsoft\SQL Server\110\Tools`

 Mit diesem Tool kann man auch neue private Instanzen erstellen:

```
SqlLocalDB create "MyPrivateInstance"
```

Hier eine schematische Üdersicht über die Befehle von SqlLocalDB: [^1]

```
SqlLocalDB.exe   
{  
      [ create   | c ] \<instance-name>  \<instance-version> [-s ]  
    | [ delete   | d ] \<instance-name>  
    | [ start    | s ] \<instance-name>  
    | [ stop     | p ] \<instance-name>  [ -i ] [ -k ]  
    | [ share    | h ] [" <user_SID> " | " <user_account> " ] " \<private-name> " " \<shared-name> "  
    | [ unshare  | u ] " \<shared-name> "  
    | [ info     | i ] \<instance-name>  
    | [ versions | v ]  
    | [ trace    | t ] [ on | off ]  
    | [ help     | -? ]  
} 
```

----------------------------------------
[^1]: [SqlLocalDB-Hilfsprogramm](https://docs.microsoft.com/de-de/sql/tools/sqllocaldb-utility)
