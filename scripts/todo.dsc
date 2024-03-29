###### gamerules:

#TODO: disable gloabl sound effects for all worlds

###### Chat:

# TODO: add function to ignore other players (no see of pns/public messages), except admins
# TODO: Mail-Funktion, Spieler die AFK oder offline sind können Botschaften erhalten. Sie erhalten Benachrichtigung sobald sie wieder da/online sind und können die Nachricht abrufen

###### Tutorial:

# TODO: if a player was offline for more than 4 months prompt him with a message to maybe redo the tutorial if he wants
# TODO: if a players playtime is < 1h and his last login is more than 2 weeks ago, prompt him with a message to redo the tutorial

####### player tools and functions:

#TODO: /spawn command available with cooldown for Besucher and veraltet ranks, players have to use consumable item for teleporting to spawn
# Spieler können Leitern hängend unter sich platzieren beim Klettern https://youtu.be/KqS27JcbrCQ 6min
# Einige der Features des Datapcks "Vanilla Refresh" https://modrinth.com/datapack/vanilla-refresh
# Spieler können ANker/pfeiler vor wichtigen Orten wie Dungeons oder Städten nutzen, um ihren Spawnpunkt zu resetten mit kleinem Tribut ... Ersatz für Betten

###### Ränge:

#TODO: when a player with rank "legend" loggs in, instead of normal login sound a goat horn sound plays

###### End Dimension:

#TODO: when a player drinks the end potion without having made it by himself, he will die
#TODO: for end potion, drop from dragon is necessary (dragon ambrosia) and an item from warden
#TODO: custom enderman who "scream" to call for support

###### Dragon fight:

#TODO: add custom music for dragon fight ... maybe c418 "0x10c", or "alpha"
#TODO: enderdragon doesn't come down to the fountain so players can hit them
#TODO: when enderdragon spawns a wave from particles rolls from the center over the arena and hurts players touching it
#TODO: endedragon has ranged attacks
#TODO: on preparing of the fight, end crystal will spawn making huge waveform explosions ... on towers they also deal huge knockback kicking off players from the towers
#TODO: for waling the enderdragon an item in the center needs to be placed, a modified endeye which needs a shard dropped by the warden
#TODO: when player starts fight with enderdragon new enderman variants will spawn, they get agressive if players uses enderpearls and won't be affected by wearing pumpkins
#TODO: hitting the enderdragon with an enderpearl let's the player ride it for a few seconds, giving the player opportunity to deal melee damage
#TODO: custom item that helps with enderdragon: arrows that shoot projectiles that follow the target ... enchantment maybe or thaumaturgie https://discord.com/channels/315163488085475337/843302108001468446/1053630923440136262

###### wither fight:

#TODO: wither doesn't do damage to surroundings
#TODO: increase droprate of witherskulls
#TODO: wither despawns after not taking damage for a certain time
#TODO: range attacks and other new attacks, so players don't cheese the fight
#TODO: new wither fight "wither king", same buildable recipe but instead of wither skulls, players need wither king skulls from wither kings (new mob)

###### farming world:

#TODO: all structures new and better with specific spots where blocks regenerate over time
#TODO: generation with datapack e.g. https://www.planetminecraft.com/data-pack/arboria-worldgen/

####### player interaction:

#TODO: attacking a player deals damage to the attacking player (all players are pieces of one killed god)

####### core protect replacement:

#TODO: log every block that's placed by a player with the uuid + name and the block location and name to make it restorable (not for farming worlds)


####### tutorial:

#TODO: show players all worlds via spectator mode (fly with Velnias to all spheres)

####### plane of the earth mother (overworld farming dungeon):

#TODO: trading villagers, can be traded with emeralds or rupees (new special ressource)
#TODO: mining valuable ressources triggers golems who want to protect the earth mother from pillaging players (they get angrier and higher in numbers the more players mine)
#TODO: mining valuable ressources triggers a ghast scream from time to time inflicting the player with mining fatigue

####### Eudämonie

#TODO: Spieler erhält mit erster eudämonischer Verzauberung "Seelenverwandt" Seelenkrug im Inventar. Dort befinden sich alle Gegenstände mit dieser Verzauberung und können aus/in das Inventar geholt werden

####### PVP

# Spieler können andere Spieler jederzeit zum Duell fordern per Rechtsklick auf den Spieler mit einer Waffe
# Die Waffe muss mit der Verzauberung "Seelentöter" verzaubert sein (Stufe I - V), die Stufe bestimmt den Schaden in absoluten Zahlen (keine Waffenoder Rüstungsboni der fairness halber)
# Schaden kann mit Schild zur Hälfte reduziert werden
# bei Annahme startet PvP sofort
# Auch Kampf in einer Arena möglich, hierzu müssen sich beide Spieler zu einem Arena teleportieren und den Kampf starten
# in Arenen erahlten beide Spieler kits und verlieren nach dem Tod keine Items
# Nach Ende des Kampfs in einer Arena werden Spieler an ihren letzten ort zurück teleportiert
# Bestenlisten mit death/kill count ratio vorhanden und absoluten Zahlen wie ANzahl der Kämpfe, Tötungen etc.

######## Verzauberungen

# Seelentöter I - V (Nahkampf- Fernkampfwaffen) - erlaubt es andere Spieler zu verletzen, sofern diese dem Kampf zustimmen, höhere Stufe = mehr Schaden
# Syphon (Shulker Boxen) - aufgesammelte Items, die auch in der verzauberten Shulker Kiste liegen werden direkt dort einsortiert statt ins Inventar zu gehen
# Seelenverwandt I - V - Items mit dieser Verzauberung bleiben nach dem Tot erhalten und erscheinen in einem Seelenkrug (craftbares Item) zum Aufsammeln, Items nehmen dabei jedoch schaden (je höher die STufe desto weniger)
# Thaumaturgisch I - V - Items mit dieser Verzauberung erlauben die Nutzung und Verbesserung mit thaumaturgischen Mechaniken (Meisterschaften, Skills etc.), höhere Stufen = mehr Effizienz


######## Jahreszeiten


######## Freunde/Feinde

######## Dungeons

# Truhen sperren/entsprren mit Schlüsselitems, die als Loot gedroppt werden können: https://meta.denizenscript.com/Docs/Search/location#locationtag.lock

######## Blaupausen

# Vorgefertigte Display Entity Module für Dekorationen - Craftingrezepte für Survival und Menüpunkt für Creative

######## Logging

# Save important player data to YAML files every day (playtime, skill-levels, quest progress, etc.)

######## Options

# AFK Nachrichten abschaltbar
# Chatsounds abstellbar
# MOTD abschaltbar
# Tipps & Tricks abschaltbar

######### Wettersystem

# Beeinflusst NPC Dialoge, manche NPCs nur bei bestimmtem Wetter an Orten
# https://meta.denizenscript.com/Docs/Search/downfall
# Wetter ändert sich nicht mehr von alleine (Gamerule), eigenes Wetter einstellen
# Wetter: Meteoritenschauer (in Sphäre der Erdenmutter mit langsamen Tempo, selten in Orbis)
# Wetter: schweres Gewitter (mehr Blitze, stärkerer Regen)
# Wetter: Blutregen/Todesnebel (Sphären mit "böser" Atmosphäre), Malus versch. Art für Spieler - ggf. Boni für Spieler mit bestimmten Göttern
# Wetter: Ascheregen (Vulkangebiete, Sphären mit "böser" Atmosphäre), weht in eine Richtung - macht Spieler langsamer oder schneller je nachdem wohin er läuft
# Wetter: Orkan/schwerer Sturm (Windgeräusche, mehr Regen)
# Wetter: Hitze/Dürre (Pflanzen vertrocknen schnell, Blätter verfärben sich ggf.), Malus für Rüstungen in Wüsten
# Wetter: Sandsturm
# Wetter: Blizzard und Schneestürme
# Wetter: Nieselregen (evtl. mit Tropfenpartikeln)
# Wetter: Blutmond
# Wetter: Nebel
# NPC, der einem das Wettter vorhersagt
# Wetter beeinflusst Wachstum von Pflanzen

########## admin tools

# anvil / loom etc. GUIs direkt aufrufbar


########## Mobs

# Mobs hinterlassen einen soul-Partikel wenn sie sterben in den Eudämonie Welten (alle außer Avarus und creative)
# Mobs mit Schild und Humanoide haben eine "Blockwahrscheinlichkeit", der Angriff des Spielers geht ins Leere und er wird ein klein wenig zurückgeworfen (evtl. Verzauberung für Rüstung um das aufzuheben)

########## Blaupausen

# Preise für das Craften eines Bauelements sind doppelt so hoch wie beim "normalen" Bauen, z. B. für eine 5x5 Steinwand werden 50 Steine statt 25 benötigt, mit Meisterschaften Kosten verringern

########## Claims/Kolonien

# Bei hinreichender Größe automatisch Marker für Dynmap setzbar








#################### LINKS/IDEAS ##########################

# https://youtu.be/Df809d8b1V4 - Mods for world generation and random tweaks
########## Spieler

# Cooldown wenn Spieler zu oft hintereinander sterben, zB durch extra Sphäre oder Minigame nach Tod




