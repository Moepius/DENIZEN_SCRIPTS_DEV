# world handler for default spawn world (world)
# players who get here will be randomly teleported to different locations in the world
# after some random time they will be telported to hortus manium

world_spawn_handler:
  type: world
  enabled: true
  debug: false
  events:
    ### prevent interaction in world "world"
    on player changes food level in:world:
    - determine cancelled
    on player picks up item in:world:
    - determine cancelled
    on player item takes damage in:world:
    - determine cancelled
    on player damages entity in:world:
    - determine cancelled
    on player drops item in:world:
    - determine cancelled
    on player drags in inventory in:world:
    - determine cancelled
    on player right clicks *item_frame|*chest|furnace|crafting_table|*_button|lever in:world:
    - determine cancelled
    on *item_frame damaged by player in:world:
    - determine cancelled
    on player damaged by player in:world:
    - determine cancelled
    on item moves from inventory in:world:
    - determine cancelled
    on player damaged in:world:
    - determine cancelled
    on player places block in:world:
    - determine cancelled
    ### entering world "world" (you can use a "matcher" -> world_flagged:serverspawn, instead of providing the world name)
    on player changes world to world_flagged:serverspawn:
    - if !<context.destination_world.has_flag[serverspawn]>:
        - stop
    # flag player that he is in world "world"
    - flag <player> player_in_world_world
    # note/save his current inventory and clear it
    - note <player.inventory> as:inventory_backup_<player.uuid>
    - inventory clear
    # change gamemode
    - adjust <player> gamemode:adventure
    # hide the player from others
    - adjust <player> hide_from_players
    ### entered world "world"
    after player changes world to world_flagged:serverspawn:
     # teleport the player to a random spawn location
    - random:
        - teleport <player> teleportlocation_world_1
        - teleport <player> teleportlocation_world_2
        - teleport <player> teleportlocation_world_3
        - teleport <player> teleportlocation_world_4
        - teleport <player> teleportlocation_world_5
        - teleport <player> teleportlocation_world_6
    # show player world title and play some sounds
    - wait 2s
    - playsound <player> sound:block_bell_resonate pitch:0.8
    - playsound <player> sound:block_beacon_power_select pitch:0.2
    - title "title:<&6>Welt der Vergessenen" stay:3s targets:<player>
    ### bring player back to hortus manium
    - random:
        - wait 1s
        - wait 3s
        - wait 5s
        - wait 7s
        - wait 9s
        - wait 20s
        - wait 30s
    - cast darkness duration:5s
    - playsound <player> sound:block_bell_resonate pitch:0.8
    - wait 2s
    - teleport <player> teleportlocation_hortusspawn
    ### changes when leaving world
    - inventory set o:inventory_backup_<player.uuid>
    - flag <player> player_in_world_world:!
    - adjust <player> stop_sound
    # change gamemode
    - adjust <player> gamemode:survival
    ### "world" sound effects and ambients
    on system time secondly every:10:
    - define p <server.online_players_flagged[player_in_world_world]>
    - foreach <[p]> as:p:
        - playsound <[p]> sound:AMBIENT_SOUL_SAND_VALLEY_LOOP