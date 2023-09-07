# # To update chat, simply start the server with the script loaded or run `/chat_update` with the permission `chat.admin`
# # Extra clickable buttons can be added by adding them to `chat_formatting` script under `data.buttons`:
#   example command:
# -    format: the format is what appears as the text button to click, eg `[Activate Fly]`
# -    command: the command is what command runs when clicked, eg: `/fly`

# TODO: delete history every few days
# TODO: delete history when it gets too big
# TODO: optimize highlitghting links
# TODO: ratelimit notifiying highlighted players to prevent spam
# TODO: let players choose nicknames and highlight them as well
# TODO: make locations have hovers with lore info, e.g. Orbis with hover info that it is our main world
# TODO: for some trigger words add a message to a new line of the message the player is typing

# TODO: move this to a task script with data containers
      #- define linkstart <list[https://|http://|www.|meta.|map.|forum.|login.]>
      #- define linkend <list[.de|.com|.net|.info|.ly|.be|.fr|.is|.biz|.to|.co|.org|.uk|.at]>
      #- define locations <list[Orbis|Avarus|Arboretum|Kaos|Orcus|Zeitkapsel|Hortusmanium|Ituria|Moraira|Blackshire]>
      #- define serverwords <list[Projektantrag|Fachgespräche|Gallerie|Projektwelt|Bauprojekt]>
      #- define misc <list[Discord|Regeln|Hilfe|Support|Wiki|Guide]>
      #- define symbols <list[?|,|:|;|!|.]>
      #- define textrpl <context.message.parse_color>
      ## loop through each word of the message and highlight links
      #- foreach <context.message.split> as:arg:
      #  - if <[linkstart].filter_tag[<[arg].starts_with[<[filter_value]>]>].any> || <[linkend].filter_tag[<[arg].ends_with[<[filter_value]>]>].any>:
      #      - define textrpl <[textrpl].replace[<[arg]>].with[<&n><[arg]><&r>]>
      ## filter out symbols like ?,:,!
      #  - if <[symbols].filter_tag[<[arg].ends_with[<[filter_value]>]>].any>:
      #      - define textrpl <[textrpl].replace[<[arg].to_list.last>].with[<&f><[arg].to_list.last><&r>]>
      ## highlitght predefined locations
      #- foreach <[locations]> as:loc:
      #    - define textrpl <[textrpl].replace[<[loc]>].with[<&c><[loc]><&r>]>
      ## highlight server words
      #- foreach <[serverwords]> as:words:
      #    - define textrpl <[textrpl].replace[<[words]>].with[<&color[<color[#DBF227]>]><[words]><&r>]>
      ## higlight player names
      #- foreach <server.online_players.exclude[<player>].include[<server.offline_players>]> as:player:
      #  - define name <[player].name>
      #  - if <[textrpl].contains_text[<[name]>]>:
      #    - define textrpl <[textrpl].replace[<[name]>].with[<&a><[name]><&r>]>
      #    - if <[player].is_online>:
      #      - playsound <[player]> sound:block_bell_use
      ## highlight and replace misc words
      #- foreach <[misc]> as:misc:
      #  - choose <[misc]>:
      #    - case Discord:
      #      - define textrpl <[textrpl].replace_text[<element[Discord]>].with[<&color[<color[#5865F2]>]>Discord<&co> <&n>https://is.gd/cdiscord<&r>]>
      #    - case Regeln rules:
      #      - define textrpl <[textrpl].replace[<element[Regeln]>].with[<element[<&color[<color[#F26800]>]><&n>Regeln].on_click[/regeln].on_hover[Klicken, um Regeln aufzurufen]><&r>]>
      #      - define textrpl <[textrpl].replace[<element[rules]>].with[<element[<&color[<color[#F26800]>]><&n>Regeln].on_click[/regeln].on_hover[Klicken, um Regeln aufzurufen]><&r>]>
      #    - case Hilfe help:
      #      - define textrpl <[textrpl].replace[<element[Hilfe]>].with[<element[<&color[<color[#F26800]>]><&n>Hilfe].on_click[/hilfe].on_hover[Klicken, um Hilfe aufzurufen]><&r>]>
      #      - define textrpl <[textrpl].replace[<element[help]>].with[<element[<&color[<color[#F26800]>]><&n>Hilfe].on_click[/hilfe].on_hover[Klicken, um Hilfe aufzurufen]><&r>]>
      #    - case Support report:
      #      - define textrpl <[textrpl].replace[<element[Support]>].with[<element[<&color[<color[#F26800]>]><&n>Support].on_click[/support].on_hover[Klicken, um Support aufzurufen]><&r>]>
      #      - define textrpl <[textrpl].replace[<element[report]>].with[<element[<&color[<color[#F26800]>]><&n>Support].on_click[/support].on_hover[Klicken, um Support aufzurufen]><&r>]>


chat_formatting:
  type: world
  debug: false
  enabled: true
  events:
    on server start server_flagged:!chat.cached:
      - run chat_formatting.sub_paths.chat_button_cache
      - run chat_formatting.sub_paths.rank_text_cache
      - flag server chat.cached

    on player chats flagged:!player.chat.busy:
      - determine cancelled passively
      # ██ [ Überprüfen Sie, ob der Player stummgeschaltet ist        ] ██
      - if <player.has_flag[player.flag.muted]>:
        - run chatsounds_error def:<player>
        - narrate format:c_warn "Ihr wurdet stummgeschaltet."
        - stop
      # ██ [ Überprüfen Sie, ob der Spieler unsere Regeln gelesen hat ] ██
      - if !<player.has_permission[craftasy.denizen.player.chat.use]>:
        - run chatsounds_error def:<player>
        - narrate format:c_warn "Akzeptiert zunächst unsere Regeln, damit ihr den Chat nutzen könnt."
        - stop
      ################## highlight player names, server locations and links
      # TODO: move this to a task script with data containers
      - define linkstart <list[https://|http://|www.|meta.|map.|forum.|login.]>
      - define linkend <list[.de|.com|.net|.info|.ly|.be|.fr|.is|.biz|.to|.co|.org|.uk|.at]>
      - define locations <list[Orbis|Avarus|Arboretum|Kaos|Orcus|Zeitkapsel|Hortusmanium|Ituria|Moraira|Blackshire]>
      - define serverwords <list[Projektantrag|Fachgespräche|Gallerie|Projektwelt|Bauprojekt]>
      - define misc <list[Discord|Regeln|Hilfe|Support|Wiki|Guide]>
      - define symbols <list[?|,|:|;|!|.]>
      - define textrpl <context.message.parse_color>
      # loop through each word of the message and highlight links
      - foreach <context.message.split> as:arg:
        - if <[linkstart].filter_tag[<[arg].starts_with[<[filter_value]>]>].any> || <[linkend].filter_tag[<[arg].ends_with[<[filter_value]>]>].any>:
            - define textrpl <[textrpl].replace[<[arg]>].with[<&n><[arg]><&r>]>
        # filter out symbols like ?,:,!
        - if <[symbols].filter_tag[<[arg].ends_with[<[filter_value]>]>].any>:
            - define textrpl <[textrpl].replace[<[arg].to_list.last>].with[<&f><[arg].to_list.last><&r>]>
        # highlitght predefined locations
        - if <[locations].filter_tag[<[arg].starts_with[<[filter_value]>]>].any>:
          - define textrpl <[textrpl].replace[<[arg]>].with[<&c><[arg]><&r>]>
        # highlight server words
        - if <[serverwords].filter_tag[<[arg].starts_with[<[filter_value]>]>].any>:
          - define textrpl <[textrpl].replace[<[arg]>].with[<&color[<color[#DBF227]>]><[arg]><&r>]>
        # higlight player names
        - foreach <server.online_players.exclude[<player>].include[<server.offline_players>]> as:player:
          - define name <[player].name>
          - if <[arg].starts_with[<[name]>]>:
            - define textrpl <[textrpl].replace[<[arg]>].with[<&a><[name]><&r>]>
            - if <[player].is_online>:
              - playsound <[player]> sound:block_bell_use
        # highlight and replace misc words
        - if <[misc].filter_tag[<[arg].starts_with[<[filter_value]>]>].any>:
          - foreach <[misc]> as:misc:
            - choose <[misc]>:
              - case Discord:
                - define textrpl <[textrpl].replace_text[<element[Discord]>].with[<&color[<color[#5865F2]>]>Discord<&co> <&n>https://is.gd/cdiscord<&r>]>
              - case Regeln:
                - define textrpl <[textrpl].replace[<element[Regeln]>].with[<element[<&color[<color[#F26800]>]><&n>Regeln].on_click[/regeln].on_hover[Klicken, um Regeln aufzurufen]><&r>]>
              - case Hilfe:
                - define textrpl <[textrpl].replace[<element[Hilfe]>].with[<element[<&color[<color[#F26800]>]><&n>Hilfe].on_click[/hilfe].on_hover[Klicken, um Hilfe aufzurufen]><&r>]>
              - case Support:
                - define textrpl <[textrpl].replace[<element[Support]>].with[<element[<&color[<color[#F26800]>]><&n>Support].on_click[/support].on_hover[Klicken, um Support aufzurufen]><&r>]>
      ################### build the text
      - define text "<player.proc[player_name_format]><&f><&co> <[textrpl]>"
      - definemap data:
          text: <[text]>
          time: <util.time_now.epoch_millis>
      - flag server server.chat.history:->:<[data]>
      - flag server server.chat.history[1]:<- if:<server.flag[server.chat.history].size.is_more_than[50].if_null[false]>
      - define messages <server.flag[server.chat.history].if_null[<list>]>
      - define channel_buttons <server.flag[server.chat.buttons].if_null[<empty>]>
      #### the message with buttons (also in "player receives message event") ####
      - foreach <server.online_players> as:player:
        - define data.uuid <[player].uuid>
        - define per_player_messages <[messages].include[<[player].flag[server.chat.history].if_null[<list>]>].sort_by_value[get[time]].parse[get[text]].if_null[<list>]>
        - narrate playerchat/<n.repeat[100]><[per_player_messages].separated_by[<&r><n>]><n.repeat[2]><[channel_buttons]> targets:<[player]> from:<player.uuid>

    on player receives message:
      - stop if:<context.message.starts_with[playerchat/]>
      # ██ [ Verwenden Sie das Chat-Format des Spielers               ] ██
      - definemap data:
          text: <context.message>
          time: <util.time_now.epoch_millis>
          uuid: <player.uuid>
      - flag player server.chat.history:->:<[data]> if:<context.system_message>
      - flag player server.chat.history[1]:<- if:<player.flag[server.chat.history].size.is_more_than[50].if_null[false]>
      - define messages <server.flag[server.chat.history].if_null[<list>].include[<player.flag[server.chat.history].if_null[<list>]>].sort_by_value[get[time]].parse[get[text]].if_null[<list>]>
      - define channel_buttons <server.flag[server.chat.buttons].if_null[<empty>]>

      #### the message with buttons (also in "player chats event") ####
      - determine message:<n.repeat[100]><[messages].separated_by[<&r><n>]><n.repeat[2]><[channel_buttons]>

    # disable/remove this line to enable errors again (prevents server from crashing due to repeated errors)
    on script generates error:
      - determine cancelled if:<context.script.name.contains_any_text[chat]>

  sub_paths:
    chat_button_cache:
      # - this just hard resets after a /chat_update
      # - foreach <server.online_players> as:player:
      #   - flag <[player]> server:!
      # - flag server server:!
      # - announce "chat cleared"
      - define buttons <list>
      - foreach <script.parsed_key[data.buttons]> as:button_data:
        #### how the buttons should look (texts via data container "data.buttons") ####
        - define button <[button_data.format].on_hover[<[button_data.hover]>].on_click[/<[button_data.command]>]>
        - define buttons <[buttons].include_single[<[button]>]>

      - flag server server.chat.buttons:<[buttons].space_separated>

      - narrate "<&a>Chat-Schaltflächen aktualisiert und zwischengespeichert!" targets:<player>

    rank_text_cache:
      - define more_info <script.parsed_key[data.more_info]>
      - define all_rank_data <script.parsed_key[data.rank_data.ranks]>
      #### how the rank prefixes should look (data taken from "data.rank_data") ####
      - foreach <[all_rank_data]> key:rank_name as:rank_data:
        #### rank prefix text ####
        - define rank_text <[rank_data.color]><[rank_data.symbol]>

        - define rank_formatted <[rank_text].on_hover[<[rank_data.info]><n><[more_info.text]>]>
        # change this line ^ to this v if you want to open link on clicking rank
        #- define rank_formatted <[rank_text].on_hover[<[rank_data.info]><n><[more_info.text]>].on_click[<[more_info.url]>].type[open_url]>

        - flag server server.rank.format.<[rank_name]>:<[rank_formatted]>
        - flag server server.rank.text.<[rank_name]>:<[rank_text]>

      - narrate "<&a>Formatierung der Spielernamen aktualisiert und zwischengespeichert!"
  data:
    buttons:
      # example:
      # fly:
      #   format: <&lb>Activate Fly<&rb>
      #   command: fly
      #   hover: Click to enable fly!
      rules:
        format: <&3><&lb><&b>Regeln<&3><&rb>
        command: rules
        hover: <&b>Ruft unsere Serverregeln auf.
      guide:
        format: <&3><&lb><&b>Guide<&3><&rb>
        command: guide
        hover: <&b>Ruft das Hilfe-Menü auf.
      support:
        format: <&3><&lb><&b>Support<&3><&rb>
        command: support
        hover: <&b>Ruft das Support-Menü auf.
      afk:
        format: <&3><&lb><&b>AFK<&3><&rb>
        command: afk
        hover: <&b>Setzt Euch <&a>AFK<&b>.

    player_chat:
      format:
        # flag: player.rank.data_name - rankname, referencing data container
        prefix: <server.flag[server.rank.format.<player.flag[player.rank.data_name].if_null[Besucher]>]>
        name: <player.name>
        hover: <script[chat_formatting].parsed_key[data.title_data.<player.flag[chat.title].if_null[player]>.text]><&b>Klicken, für Privatnachricht
        suggest_command: /pn <player.name><&sp>

    more_info:
      text: <&b>Mehr Infos in unserem Wiki <&a><&n>craftasy.de/wiki<&b>.
      url: https://www.craftasy.de/wiki

    rank_data:
      ranks:
        Besucher:
          color: <&7>
          symbol: •
          info: <&7><&l>Besucher<&nl><&b>Neuer Spieler, nicht freigeschaltet.
        Veraltet:
          color: <&7>
          symbol: ❈
          info: <&7><&l>Veraltet<&nl><&b>Spieler, der noch nicht vom alten Rangsystem konvertiert wurde.<&nl><&f>--------------------
        Vagabund:
          color: <&a>
          symbol: ✲
          info: <&a><&l>Vagabund<&nl><&b>Neuer Spieler, freigeschaltet und Tutorial abgeschlossen.<&nl><&f>--------------------
        Pfadfinder:
          color: <&2>
          symbol: ❊
          info: <&2><&l>Pfadfinder<&nl><&b>Spieler, die mindestens 15 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Pionier:
          color: <&b>
          symbol: ❉
          info: <&b><&l>Pionier<&nl><&b>Spieler, die mindestens 45 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Entdecker:
          color: <&3>
          symbol: ❈
          info: <&3><&l>Entdecker<&nl><&b>Spieler, die mindestens 125 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Siedler:
          color: <&d>
          symbol: ✶
          info: <&d><&l>Siedler<&nl><&b>Stammspieler, die mindestens 500 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Gruender:
          color: <&5>
          symbol: ✷
          info: <&5><&l>Gründer<&nl><&b>Stammspieler, die mindestens 1000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Legende:
          color: <&6>
          symbol: ✸
          info: <&6><&l>Legende<&nl><&b>Stammspieler, die mindestens 2000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Legende II:
          color: <&6>
          symbol: ✸
          info: <&6><&l>Legende <&f><&lb><&6><&l>II<&f><&rb><&nl><&b>Stammspieler, die mindestens 2500 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Legende III:
          color: <&6>
          symbol: ✸
          info: <&6><&l>Legende <&f><&lb><&6><&l>III<&f><&rb><&nl><&b>Stammspieler, die mindestens 3000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Legende IV:
          color: <&6>
          symbol: ✸
          info: <&6><&l>Legende <&f><&lb><&6><&l>IV<&f><&rb><&nl><&b>Stammspieler, die mindestens 4000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------
        Legende V:
          color: <&6>
          symbol: ⦑✸⦒
          info: <&6><&l>Legende <&f><&lb><&6><&l>V<&f><&rb><&nl><&b>Stammspieler, die mindestens 5000 Stunden<&nl><&b>auf unserem Server verbracht haben.<&nl><&f>--------------------

    title_data:
      player:
        text: <&7>Spieler<n>
        info: <&7>Ein Spieler
      admin:
        text: <&c>Administrator<n>
        info: <&c>

player_name_format:
  type: procedure
  debug: false
  definitions: player
  script:
    # long, verbose version
    - define player_prefix <script[chat_formatting].parsed_key[data.player_chat.format.prefix]>
    - define player_name <script[chat_formatting].parsed_key[data.player_chat.format.name]>
    - define hover <script[chat_formatting].parsed_key[data.player_chat.format.hover]>
    - define suggest_command <script[chat_formatting].parsed_key[data.player_chat.format.suggest_command]>
    #### formatting of the full player/message prefix ####
    - determine "<&7><util.time_now.format[HH:mm].on_hover[<&f><util.time_now.format[dd.MM.yyyy]> um <util.time_now.format[HH:mm]> Uhr]> <[player_prefix]><&f> ⎜ <[player_name].on_hover[<[hover]>].on_click[<[suggest_command]>].type[suggest_command]>"

    # short instant version
    # - determine "<script.parsed_key[data.player_chat.format.prefix]><&f> ⎜ <script.parsed_key[data.player_chat.format.name].on_hover[<script.parsed_key[data.player_chat.format.hover]>].on_click[<script.parsed_key[data.player_chat.format.suggest_command]>].type[suggest_command]>"

chat_update_command:
  type: command
  debug: false
  name: chat_update
  description: Chatdaten aktualisieren
  usage: /chat_update
  permission: chat.admin
  script:
    - if !<context.args.is_empty>:
      - narrate "<&c>Dieser Befehl benötigt keine Parameter."
      - run chatsounds_error def:<player>
      - stop

    - run chat_formatting.sub_paths.chat_button_cache
    - run chat_formatting.sub_paths.rank_text_cache
    - flag server chat.cached