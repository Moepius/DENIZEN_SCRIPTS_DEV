



world_rank_handler:
    type: world
    debug: false
    events:
        on player joins:
        - if !<player.has_flag[player.flag.joinedfirsttime]>:
            - if <player.statistic[play_one_minute]> > 100:
                - flag <player> player.flag.joinedfirsttime
            - else:
                - run task_player_join_first_time def:<player>
                - flag <player> player.flag.rank.data:<script[data_rank_info].parsed_key[besucher]>
                - flag <player> player.flag.rank.name:besucher
                - flag <player> player.flag.no_motd
                - stop
        - if !<player.has_flag[player.flag.rank_converted]>:
            - flag <player> player.flag.rank.data:<script[data_rank_info].parsed_key[veraltet]>
            - flag <player> player.flag.rank.name:veraltet
            - flag <player> player.flag.no_motd
            - wait 2s
            - run task_player_not_converted def:<player>
        - else:
            - run task_player_rank_update def:<player>
            - flag <player> player.flag.no_motd:!

task_player_join_first_time:
    type: task
    definitions: player
    script:
        - narrate "Willkommen auf Craftasy!" targets:<[player]>
        - narrate "work in progress" targets:<[player]>

task_player_rank_update:
    type: task
    definitions: player
    script:
        - narrate "Rangupdate im Gange ..." targets:<[player]>

task_player_not_converted:
    type: task
    definitions: player
    script:
        - narrate "<&b>Testbegrüßung für Spieler, die ihren Rang noch nicht konvertiert haben." targets:<[player]>

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


data_title_info:
    type: data
    debug: true
    player:
        titlename: <&7>Spieler
        titleinfo: <&7>Ein Spieler
    admin:
        titlename: <&c>Administrator
        titleinfo: <&c>
