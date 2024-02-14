# handling of the world "zeitkapsel" where players can explore our old projects

# klassische MC Musik:
# MUSIC_OVERWORLD_JUNGLE|MUSIC_CREATIVE|MUSIC_OVERWORLD_FROZEN_PEAKS|MUSIC_OVERWORLD_OLD_GROWTH_TAIGA|MUSIC_OVERWORLD_SNOWY_SLOPES|MUSIC_OVERWORLD_SPARSE_JUNGLE

# Hinweis via Toast bzw. Info Einblendung

# teleportlocation_zeitkapsel-hortus

# zeitreise locations:
# location_zeitkapsel_ituria2011
# location_zeitkapsel_ituria2012
# location_zeitkapsel_ituria2013
# location_zeitkapsel_ituria2014
# location_zeitkapsel_ituria2015
# location_zeitkapsel_ituria2018
# location_zeitkapsel_tiuacen2014
# location_zeitkapsel_caldera2014

# spawn: 736 152 -268
# ituria 2011: 3481 71 -1152
# ituria 2012: 1086 95 -1228
# ituria 2013: 867 95 -3319
# ituria 2014: -1017 94 -1373
# ituria 2015: -2060 94 -3782
# ituria 2018: 3461 94 -3393
# tiuacen 2014: 888 78 3422
# caldera 2014: -2198 69 1909

# TODO: Seelenpartikel auf SPawninsel gelegentlich
# TODO: Musik sobald Spieler alte Welten besucht mit resource pack
# TODO: Protection: shulker, dispenser, schilder, usw.

zeitreise_inventory:
    type: inventory
    debug: false
    inventory: chest
    title: <&f><&l>Zeitreise
    gui: true
    slots:
    - [zeitkapsel_ituria2011] [zeitkapsel_ituria2012] [zeitkapsel_ituria2013] [zeitkapsel_ituria2014] [zeitkapsel_ituria2015] [zeitkapsel_ituria2018] [air] [air] [air]
    - [zeitkapsel_tiuacen2014] [air] [air] [air] [air] [air] [air] [air] [air]
    - [zeitkapsel_caldera2014] [air] [air] [air] [air] [air] [air] [air] [gui_close]

zeitkapsel_handler:
  type: world
  enabled: true
  debug: false
  events:
    # prevent interaction in zeitkapsel world
    on player changes food level in:zeitkapsel:
      - determine cancelled
    on player swaps items flagged:player_in_world_zeitkapsel:
      - determine cancelled
    on player picks up item in:zeitkapsel:
      - determine cancelled
    on player item takes damage in:zeitkapsel:
      - determine cancelled
    on player damages entity in:zeitkapsel:
      - determine cancelled
    on player drops item in:zeitkapsel:
      - determine cancelled
    on player drags in inventory in:zeitkapsel:
      - determine cancelled
    on player right clicks *item_frame|*chest|furnace|crafting_table|*_button|lever in:zeitkapsel:
      - determine cancelled
    on *item_frame damaged by player in:zeitkapsel:
      - determine cancelled
    on player damaged by player in:zeitkapsel:
      - determine cancelled
    on item moves from inventory in:zeitkapsel:
      - determine cancelled
    on player damaged in:zeitkapsel:
      - determine cancelled
    on player places block in:zeitkapsel:
      - determine cancelled
    ### entering zeitkapsel world
    on player changes world to zeitkapsel:
      # flag player that he is in zeitkapsel world
      - flag <player> player_in_world_zeitkapsel
      # change gamemode
      - adjust <player> gamemode:adventure
      # note/save his current inventory and clear it
      - note <player.inventory> as:inventory_hortusbackup_<player.uuid>
      - inventory clear
      # give player zeitkapsel inventory with buttons
      - if !<player.has_flag[visited_zeitkapsel]>:
        - flag <player> visited_zeitkapsel
        - inventory set o:inventory_zeitkapsel_first
      - else:
        - inventory set o:inventory_zeitkapsel_<player.uuid>
      # show player zeitkapsel title and play some sounds
      - wait 2s
      - playsound <player> sound:block_bell_resonate pitch:0.8
      - playsound <player> sound:block_beacon_power_select pitch:0.2
      - title "title:<&6>Zeitkapsel" "subtitle:<&f>Ituria ????" stay:3s targets:<player>
      # play a random song from playlist after 5s
      - if <player.has_flag[zeitkapsel_setting_musicoff]>:
        - stop
      - if <player.has_flag[zeitkapsel_songplaying]>:
          - stop
      - flag <player> zeitkapsel_playlist:MUSIC_OVERWORLD_JUNGLE|MUSIC_CREATIVE|MUSIC_OVERWORLD_FROZEN_PEAKS|MUSIC_OVERWORLD_OLD_GROWTH_TAIGA|MUSIC_OVERWORLD_SNOWY_SLOPES|MUSIC_OVERWORLD_SPARSE_JUNGLE
      - flag <player> zeitkapsel_songplaying expire:5m
      - wait 5s
      - define song <list[<player.flag[zeitkapsel_playlist]>].random>
      - flag <player> zeitkapsel_playlist:<-:<[song]>
      - playsound <player> sound:<[song]>
    ### exiting zeitkapsel world
    on player changes world from zeitkapsel:
      - flag <player> player_in_world_zeitkapsel:!
      - flag <player> zeitkapsel_songplaying:!
      - inventory clear
      - inventory set o:inventory_hortusbackup_<player.uuid>
      - adjust <player> stop_sound
      # change gamemode
      - adjust <player> gamemode:survival
      - teleport <player> teleportlocation_zeitkapsel-hortus
    ### save the zeitkapsel inventory every few ticks
    ### (workaround because somehow when saving the inventory on the "changes from zeitkapsel", saves the wrong inventory)
    on delta time secondly:
      - define player <server.online_players_flagged[player_in_world_zeitkapsel]>
      - foreach <[player]> as:p:
        - note <[p].inventory> as:inventory_zeitkapsel_<[p].uuid>
    ### inventory buttons for controls in zeitkapsel world
    on player right clicks block with:zeitkapsel_zurueck:
      - determine cancelled passively
      - flag <player> player_in_world_zeitkapsel:!
      - inventory clear
      - inventory set o:inventory_hortusbackup_<player.uuid>
      - adjust <player> stop_sound
      # change gamemode
      - adjust <player> gamemode:survival
      - teleport <player> teleportlocation_zeitkapsel-hortus
    # set music off
    on player right clicks block with:zeitkapsel_musikaus:
      - determine cancelled passively
      - adjust <player> stop_sound
      - take slot:9
      - give zeitkapsel_musikein slot:9
      - flag <player> zeitkapsel_setting_musicoff
      - note <player.inventory> as:inventory_zeitkapsel_<player.uuid>
      - inventory update
    # set music on
    on player right clicks block with:zeitkapsel_musikein:
      - determine cancelled passively
      - take slot:9
      - give zeitkapsel_musikaus slot:9
      - flag <player> zeitkapsel_setting_musicoff:!
      - note <player.inventory> as:inventory_zeitkapsel_<player.uuid>
      - inventory update
    # open zeitreise inventory
    on player right clicks block with:zeitkapsel_zeitbutton:
      - determine cancelled passively
      - inventory open d:zeitreise_inventory
      - ratelimit <player> 3m
      - playsound <player> sound:block_bell_use
    # teleport player to a zeitkapsel location
    on player right clicks zeitkapsel_* in zeitreise_inventory:
      - playsound <player> sound:block_bell_resonate
      - cast blindness duration:1.5s
      - teleport <player> location_<context.item.script.name>
    ### music playing in background
    on delta time minutely every:8:
      - define player <server.online_players_flagged[player_in_world_zeitkapsel]>
      - foreach <[player]> as:p:
        - if <[p].has_flag[zeitkapsel_setting_musicoff]>:
          - stop
        - if <[p].has_flag[zeitkapsel_songplaying]>:
          - stop
        # if the playlist is empty, refill it
        - if <list[<[p].flag[zeitkapsel_playlist]>].size> == 0:
          - flag <[p]> zeitkapsel_playlist:MUSIC_OVERWORLD_JUNGLE|MUSIC_OVERWORLD_FLOWER_FOREST|MUSIC_CREATIVE|MUSIC_OVERWORLD_FROZEN_PEAKS|MUSIC_OVERWORLD_OLD_GROWTH_TAIGA|MUSIC_OVERWORLD_SNOWY_SLOPES|MUSIC_OVERWORLD_SPARSE_JUNGLE
        # get a random song from the playlist
        - define song <list[<[p].flag[zeitkapsel_playlist]>].random>
        # remove the chosen song from the playlist
        - flag <[p]> zeitkapsel_playlist:<-:<[song]>
        # play the song
        - playsound <[p]> sound:<[song]>
        # give player flag that a song is currently playling
        - flag <[p]> zeitkapsel_songplaying expire:5m
    ### play teleports for specific locations in zeitkapsel world
    on player enters area_zeitkapsel_caldera2014_offshorebhafen-hafen:
      - playsound <player> sound:ENTITY_BOAT_PADDLE_WATER
      - teleport <player> location_zeitkapsel_caldera2014_offshorebhafen-hafen
    on player enters area_zeitkapsel_caldera2014_hafen-offshorebhafen:
      - playsound <player> sound:ENTITY_BOAT_PADDLE_WATER
      - teleport <player> location_zeitkapsel_caldera2014_hafen-offshorebhafen
zeitkapsel_zeitbutton:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Zeitkapsel öffnen<&3><&l>]
  mechanisms:
    skull_skin: a0221485-0d78-47df-9dcd-773eaec45dbd|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzZjMGQwNDU5YzY3ZjJiZTgyZmJlNTQwNmFiOGQxMzc4ZGExZjI4ZjdhM2Y4MmYxZGZjNDc2MTVhOTU1YTcifX19
  lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Zeitkapsel Menü zu öffnen.

zeitkapsel_zurueck:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Zeitkapsel verlassen<&3><&l>]
  mechanisms:
    skull_skin: bbf760b3-5f9c-44ae-a84a-06f4314c935e|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRmNWMyZjg5M2JkM2Y4OWNhNDA3MDNkZWQzZTQyZGQwZmJkYmE2ZjY3NjhjODc4OWFmZGZmMWZhNzhiZjYifX19
  lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Zeitkapsel zu verlassen.

zeitkapsel_musikein:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Musik einschalten<&3><&l>]
  mechanisms:
    skull_skin: 485d382a-eb29-426f-b89c-786c50b6bb3b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzZhYTQxZTg0ZjA2MmZhODM4NmUxZDdjMWE2MjBhMzliOTlhMTEyNTgyOTBhYjNlZjE1YTI1NWQ4N2JlMDQwZiJ9fX0=
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Musik einzuschalten.

zeitkapsel_musikaus:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Musik abschalten<&3><&l>]
  mechanisms:
    skull_skin: caeef753-0027-40ba-9251-6661cb757a24|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGViOGJkMTgyMjg0OTNmMGYxMzkwNDBmM2JjZWYxODdhYmZhODIxNzYzMWQ5ZTE4NGY0OTliYzY3OTE4NzhiMSJ9fX0=
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Musik abzuschalten.

# world buttons
zeitkapsel_ituria2011:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2011<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2011 zu reisen.

zeitkapsel_ituria2012:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2012<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2012 zu reisen.

zeitkapsel_ituria2013:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2013<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2013 zu reisen.

zeitkapsel_ituria2014:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2014<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2014 zu reisen.

zeitkapsel_ituria2015:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2015<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2015 zu reisen.

zeitkapsel_ituria2018:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Ituria 2018<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Ituria
    - <&b>im Jahr 2018 zu reisen.

zeitkapsel_tiuacen2014:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Tiuacen 2014<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Tiuacen
    - <&b>im Jahr 2014 zu reisen.

zeitkapsel_caldera2014:
  type: item
  debug: false
  material: player_head
  display name: <&3><&l>[<&6><&l>Caldera 2014<&3><&l>]
  mechanisms:
    skull_skin: 6461582f-e959-406b-9b33-b004a7d3c171|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTBlNTU1ZTQyYTFiMmY4NWVmMmQ3NTY2ODI1NzY3NmJjM2I0ZDRmOWFkODhhZjQxODlmMWY1NjJjZDM5MzQzIn19fQ==
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um nach Caldera
    - <&b>im Jahr 2014 zu reisen.