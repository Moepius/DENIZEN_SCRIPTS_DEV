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
    debug: false
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
        - if <player.has_flag[player.flag.spammed]> && !<player.has_permission[craftasy.denizen.player.chat.spam_bypass]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr schreibt zu viel, bitte warten."
            - stop
        ###################################
        # Building the message
        ####################################
        - define title "<script[data_title_info].parsed_key[<player.flag[player.flag.title.name]>.titlename].if_null[no data!]>"
        - definemap player_format:
            prefix: <element[<script[data_rank_info].parsed_key[<player.flag[player.flag.rank.name]>.rankcolor]><script[data_rank_info].parsed_key[<player.flag[player.flag.rank.name]>.ranksymbol]>].on_hover[<script[data_rank_info].parsed_key[<player.flag[player.flag.rank.name]>.rankinfo]>]>
            name: <script[data_rank_info].parsed_key[<player.flag[player.flag.rank.name]>.rankcolor]><player.name.on_hover[<[title]><&nl><&b>Klicken, für Privatnachricht].on_click[/pn <player.name> ].type[SUGGEST_COMMAND]>
        - announce "<&f><&lb.bold><[player_format.prefix]><&f><&rb.bold> <[player_format.name]><&f><&co> <context.message.parse_color>"


#ex narrate <player.flag[datakey_test].parsed_key[legende.rankname]> um einzelne Daten aus dem data script zu ziehen
# <&r> um Buchstabenformat zu resetten
# <&lb.bold> um direkt im Tag zu formatieren
# Befehl, um SPieler mit spezifischem Datakey zu flaggen:
# flag <player> player.flag.rank.name:name
# flag <player> player.flag.title.name:name


