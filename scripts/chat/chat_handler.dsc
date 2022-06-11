#
#
#
#
# flags:
#  rank flags: player.rank
#
#
#

chat_handler:
    type: world
    debug: true
    events:
        on player chats:
        - determine passively cancelled
        - flag <player> player.flag.chat_counter:++ expire:15s
        - if <player.flag[player.flag.chat_counter]> >= 10:
            - flag <player> player.flag.spammed expire:30s
            - flag <player> player.flag.chat_counter:0
        ####################################
        # Handling cases
        ####################################
        - if <player.has_flag[player.flag.muted]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr wurdet stummgeschaltet."
            - stop
        - if !<player.has_permission[craftasy.denizen.player.chat.use]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Akzeptiert zunächst unsere Regeln, damit ihr den Chat nutzen könnt."
            - stop
        - if <player.has_flag[player.flag.spammed]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr schreibt zu viel, bitte warten."
            - stop
        ###################################
        # Building the message
        ####################################
        - definemap player_format:
            prefix: <element[<player.flag[player.flag.rankcolor]><player.flag[player.flag.ranksymbol]>].on_hover[<script[data_rank_info].parsed_key[legende.rankinfo]>]>
            name: <player.name.on_hover[<&b>Klicken, für Privatnachricht].on_click[/pn <player.name> ].type[SUGGEST_COMMAND]>
            suffix: <element[Suffix].on_hover[Infos zum Suffix]>
        - announce "<&f><&l>[<[player_format.prefix]><&f><&l>] <player.flag[player.flag.rankcolor]><[player_format.name]> <player.flag[player.flag.suffixcolor]><[player_format.suffix]><&f><&co> <context.message.parse_color>"


#ex narrate <player.flag[datakey_test].parsed_key[legende.rankname]> um einzelne Daten aus dem data script zu ziehen

data_rank_info:
    type: data
    debug: true
    besucher:
        rankcolor: <&7>
        ranksymbol: •
        rankname: Besucher
        rankinfo: <&7><&l>Gast<&nl><&b>Neuer Spieler, nicht freigeschaltet.<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    veraltet:
        rankcolor: <&7>
        ranksymbol: ❈
        rankname: Veraltet
        rankinfo: <&7><&l>Veraltet<&nl><&b>Spieler, der noch nicht vom alten Rangsystem konvertiert wurde.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    vagabund:
        rankcolor: <&a>
        ranksymbol: ✲
        rankname: Vagabund
        rankinfo: <&a><&l>Vagabund<&nl><&b>Neuer Spieler, freigeschaltet und Tutorial abgeschlossen.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    pfadfinder:
        rankcolor: <&2>
        ranksymbol: ❊
        rankname: Pfadfinder
        rankinfo: <&2><&l>Pfadfinder<&nl><&b>Spieler, die mindestens 15 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    pionier:
        rankcolor: <&b>
        ranksymbol: ❉
        rankname: Pionier
        rankinfo: <&b><&l>Pionier<&nl><&b>Spieler, die mindestens 45 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    entdecker:
        rankcolor: <&3>
        ranksymbol: ❈
        rankname: Entdecker
        rankinfo: <&3><&l>Entdecker<&nl><&b>Spieler, die mindestens 125 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    siedler:
        rankcolor: <&d>
        ranksymbol: ✶
        rankname: Siedler
        rankinfo: <&d><&l>Siedler<&nl><&b>Stammspieler, die mindestens 500 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    gruender:
        rankcolor: <&5>
        ranksymbol: ✷
        rankname: Gründer
        rankinfo: <&5><&l>Gründer<&nl><&b>Stammspieler, die mindestens 1000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
    legende:
        rankcolor: <&6>
        ranksymbol: ✸
        rankname: Legende
        rankinfo: <&6><&l>Legende<&nl><&b>Stammspieler, die mindestens 2000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------<&nl><&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.


# konvertierte Spieler müssen zusätzlich 15 Stunden spielen, um den nächsten Rang zu erhalten
