# test for if a player is afk and handling stuff
# TODO: disable actions when player is afk (receiving private Messages, getting hurt by players, collecting experience orbs and skills, items, etc.)

afk_command_example:
  type: command
  debug: false
  name: afk
  description: shit
  usage: /afk
  script:
    - narrate format:c_info "<player.name> hat sich <&a>AFK<&b> gesetzt." targets:<server.online_players.exclude[<player>]>
    - narrate format:c_info "Ihr seid nun <&a>AFK<&b>." targets:<player>
    - flag <player> player.core.afk.state:true

is_afk:
  type: procedure
  debug: false
  definitions: player
  script:
    - if <[player].has_flag[player.core.afk.state]>:
      - determine <[player].flag[player.core.afk.state]>
    - determine false

toggle_afk:
  type: task
  debug: false
  definitions: state
  script:
    - if !<player.has_flag[player.core.afk]>:
      - flag <player> player.core.afk.state:false
      - flag <player> player.core.afk.time:<util.time_now>
    - flag <player> player.core.afk.location:<player.location.block>
    - if <[state]||null> == null:
      - define state <player.flag[player.core.afk.state].not>
    - if !<[state]>:
      - flag <player> player.core.afk.time:<util.time_now>
    # Only process changes beyond this
    - if <[state]> == <player.flag[player.core.afk.state]>:
      - stop
    - flag <player> player.core.afk.state:<[state]>
    - if <[state]>:
      - narrate format:c_info "Ihr seid nun <&a>AFK<&b>." targets:<player>
      - narrate format:c_info "<player.name> ist nun <&a>AFK<&b>." targets:<server.online_players.exclude[<player>]>
      - adjust <player> glowing:true
      - adjust <player> glow_color:red
      # spawn afk entity (text display) and flag the player with it using the save argument: https://meta.denizenscript.com/Docs/Languages/the%20save%20argument
      - spawn afk_entity <player.location.add[0,2,0]> save:afk_entity
      - flag <player> afk_entity:<entry[afk_entity].spawned_entity>
      # flag player for beeing afk
      - flag <player> player.core.afk.isafk
    - else:
      - narrate format:c_info "Ihr seid nicht mehr <&a>AFK<&b>." targets:<player>
      - narrate format:c_info "<player.name> ist nicht länger <&a>AFK<&b>." targets:<server.online_players.exclude[<player>]>
      - adjust <player> glowing:false
      # remove afk entity (text display)
      - remove <player.flag[afk_entity]>
      - flag <player> afk_entity:!
      - flag <player> player.core.afk.isafk:!

afk_entity:
    type: entity
    debug: false
    entity_type: text_display
    mechanisms:
        text: <&f><&lb><&c>AFK<&f><&rb>
        pivot: vertical
        see_through: false
        text_shadowed: true

afk_events:
  type: world
  debug: false
  events:
    on system time secondly every:1:
      - foreach <server.online_players> as:p:
        - if !<[p].has_flag[player.core.afk]> || <[p].flag[player.core.afk.location]> != <[p].location.block>:
          - run toggle_afk def:false player:<[p]>
        - else if <[p].flag[player.core.afk.time].from_now.in_minutes> > 6:
          - run toggle_afk def:true player:<[p]>
          - if <[p].flag[player.core.afk.time].from_now.in_minutes> > 30:
            - if <[p].has_permission[player.core.afk.bypass]>:
                - foreach next
            - else:
                - kick <[p]> "reason:Ihr wart zu lange AFK"
    on player clicks block flagged:player.core.afk:
      - run toggle_afk def:false
    on player chats flagged:player.core.afk:
      - run toggle_afk def:false
    on command flagged:player.core.afk:
      - run toggle_afk def:false
    on player joins:
      - run toggle_afk def:false
    on player quits:
      - adjust <player> glowing:false
      # remove afk entity (text display)
      - remove <player.flag[afk_entity]>
      - flag <player> afk_entity:!
      - flag <player> player.core.afk:!

afk_restrictions:
  type: world
  debug: false
  events:
    on player absorbs experience flagged:player.core.afk.isafk:
      - determine cancelled
    on player damages block flagged:player.core.afk.isafk:
      - determine cancelled
