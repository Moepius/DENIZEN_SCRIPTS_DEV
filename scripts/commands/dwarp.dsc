#
# Craftasy dwarp
# author: Moepius
# version: 1.0.2
#
# ###############

# READ ME
# This script allows users to use a command /dwarp, after they visited at least one outpost
# after using the command, a gui will show up
# the gui consists of 9 slots, each holding one location to warp to, provided the player visited that location before
# if the player did not visit that location, the spot will be filled in with a placeholder
# the last slot contains a cancel button

# to add more locations first set up a cuboid note with the following naming convention: area_note_<name here> (use cuboid tool for easier selection https://forum.denizenscript.com/resources/cuboid-selector-tool.1)
# then set up a location note to warp to: dieweite_teleportpunkt_<name here>
# add a new inventory item
# fill in the spots how you prefer, replacing "dwarp_id" with the id you want to use and "dwarp_display" with a name to display
# add the id to all places needed (watch out for "id here" comment)
# add a event for your new region in "freebuild_outpost_enter", watch out for the comment
# done
#

#
# warp menu gui (opens after using /dwarp)
#
DWarp_Menu:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  size: 9
  title: <&l>Craftasy Schnellreise
  procedural items:
# id here (after foreach it should look like this: someid|someotherid|yourid ...)
    - foreach teljazan|bastion|vignetocorvo:
      - if <player.has_flag[unlock_item_<[value]>]>:
        - define item dwarp_item_<[value]>
      - else:
        - define item dwarp_unknown_item
      - define list:->:<[item]>
    - determine <[list]>
  slots:
  - [] [] [] [] [] [] [] [] [dwarp_cancel_item]
#
# command opening the warp menu
#
DWarp_command:
  type: command
  debug: false
  name: dwarp
  description: DWarp
  usage: /dwarp
  script:
    - if <player.has_flag[command_unlock]>:
      - inventory open d:DWarp_Menu
    - else:
      - narrate format:c_info "<&c>Ihr müsst mindestens einen Außenposten in der Weite erkunden, um die Schnellreise nutzen zu können."
#
# inventory items
#
dwarp_cancel_item:
  type: item
  material: barrier
  display name: <&c>Schließen
  lore:
    - <&7>Hier klicken, um das Menü zu schließen
dwarp_unknown_item:
  type: item
  material: coal_block
  display name: <&c>Unbekannt
  lore:
    - <&7>Nicht entdeckter Außenposten
dwarp_item_teljazan:
  type: item
  debug: false
  material: beacon
  display name: <&3><&l>Tel-Jazan
  flags:
    dwarp_id: teljazan
    dwarp_display: Tel-Jazan
  lore:
    - <&a><&o>Außenposten
    - <empty>
    - <&3><&l><&gt><&gt><&6> Klickt zum Reisen
dwarp_item_bastion:
  type: item
  debug: false
  material: beacon
  display name: <&3><&l>Die grüne Bastion
  flags:
    dwarp_id: bastion
    dwarp_display: Die grüne Bastion
  lore:
    - <&a><&o>Außenposten
    - <empty>
    - <&3><&l><&gt><&gt><&6> Klickt zum Reisen
dwarp_item_vignetocorvo:
  type: item
  debug: false
  material: beacon
  display name: <&3><&l>Vigneto Corvo
  flags:
    dwarp_id: vignetocorvo
    dwarp_display: Vigneto Corvo
  lore:
    - <&a><&o>Außenposten
    - <empty>
    - <&3><&l><&gt><&gt><&6> Klickt zum Reisen
# add new item here, don't forget to replace dwarp_id and dwarp_display

#
# event firing after player enters noted cuboid area, runs the flagging task afterwards
#
freebuild_outpost_enter:
  type: world
  debug: false
  events:
    on player enters area_note_bastion:
      - run freebuild_outpost_fasttravel_unlock "def:bastion|Die grüne Bastion"
    on player enters area_note_teljazan:
      - run freebuild_outpost_fasttravel_unlock def:teljazan|Tel-Jazan
    on player enters area_note_vignetocorvo:
      - run freebuild_outpost_fasttravel_unlock "def:vignetocorvo|Vigneto Corvo"
#   add new region here
#   on player enters <noted cubiod area name>:
#     - run freebuild_outpost_fasttravel_unlock def:<your dwarp_id>|your display name

#
# task, setting up flags to be able to use /dwarp and the items in inventory slots
#
freebuild_outpost_fasttravel_unlock:
  type: task
  debug: false
  definitions: dwarp_id|dwarp_display
  script:
    - if !<player.has_flag[unlock_item_<[dwarp_id]>]>:
        - title title:<&a><[dwarp_display]> "subtitle:<gold>Schnellreisepunkt erkundet"
        - playsound <player> sound:BLOCK_ENDER_CHEST_OPEN pitch:0.5
        - flag <player> command_unlock:true
        - flag <player> unlock_item_<[dwarp_id]>:<[dwarp_id]>
    - else:
        - title title:<&a><[dwarp_display]>
#
# click event in GUI
#
DWarp_world:
  type: world
  debug: false
  events:
    after player clicks dwarp_item_* in DWarp_Menu:
      - if <player.has_flag[unlock_item_<context.item.flag[dwarp_id]>]>:
          - run dwarp_teleportation_task def:<context.item.flag[dwarp_id]>|<context.item.flag[dwarp_display]>
      - else:
        - narrate format:c_info "<&c>Dieser Außenposten wurde noch nicht erkundet."
    after player clicks dwarp_cancel_item in DWarp_Menu:
      - inventory close
dwarp_teleportation_task:
  type: task
  debug: false
  definitions: dwarp_id|dwarp_display
  script:
    - teleport <player> dieweite_teleportpunkt_<[dwarp_id]>
    - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
    - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
    - narrate "<&3><&l> Ihr reist nach '<[dwarp_display]>'"