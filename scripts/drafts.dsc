# drafts and random tags I might use later

# LINKS TO COOL SCRIPTS AND IDEAS

# https://forum.denizenscript.com/resources/incomplete-elevator-script.121/ ... incomplete elevator script with moving plattform

# show a mark over NPCs head (copied from Denizen Discord, maybe use it later for a ascript)
# not working yet
quest_show_mark:
    type: task
    definitions: npc|player|mark
    debug: false
    script:
    - if <[mark]> == question:
        - define mark <item[quest_question_item]>
    - else:
        - define mark <item[quest_exclamation_item]>
    - define origin <[npc].location.above[0.8]>
    - spawn armor_stand[equipment=<list[<item[air]>|<item[air]>|<item[air]>|<[mark]>]>;visible=false;gravity=false;custom_name=<[player].uuid>] <[origin]>
    - define armor <[npc].location.above[0.5].find_entities[armor_stand].within[1]>
    - foreach <[armor]> as:i:
        - if <[i].custom_name.exists> and <[i].custom_name> == <[player].uuid>:
            - define armor <[i]>
            - foreach stop
    - adjust <[armor]> hide_from_players
    - adjust <[player]> show_entity:<[armor]>
    - define tick 0
    - while <[armor].is_spawned>:
        - define tick <[tick].add[1]>
        - teleport <[armor]> <[origin].rotate_yaw[<[tick].mul[10]>].forward_flat[0.25].above[<[tick].div[5].sin.div[10]>]>
        - wait 1t


# how to lock a player from moving
#- define orig_fly_speed <player.fly_speed>
#- adjust <player> flying:true
#- adjust <player> fly_speed:0
#- teleport <player> <player.location.above[0.01]>
#...
#- adjust <player> flying:false
#- adjust <player> fly_speed:<[orig_fly_speed]>
#

# use "spawn argument" to have players a text display appear over their head

## spawn afk entity (text display) and flag the player with it using the save argument: https://meta.denizenscript.com/Docs/Languages/the%20save%20argument
#- spawn afk_entity <player.location.add[0,2,0]> save:afk_entity
#- flag <player> afk_entity:<entry[afk_entity].spawned_entity>


###### item lore cost display, as seen here:https://discord.com/channels/315163488085475337/843302108001468446/1151287639887065111
inventory_cost_display:
  type: world
  debug: false
  events:
    on player opens inventory:
      - foreach <player.inventory.map_slots> as:item:
        - if <[item].has_flag[cost]>:
          - if <[item].has_lore>:
            - define lore <[item].lore>
          - else:
            - define lore <list>
          - define new_lore "<[lore].include[<green>Cost: $<[item].flag[cost]>]>"
          - inventory adjust slot:<[key]> lore:<[new_lore]>

    on player closes inventory:
      - foreach <player.inventory.map_slots> as:item:
        - if <[item].has_flag[cost]>:
          - if <[item].has_lore>:
            - define lore <[item].lore>
          - else:
            - define lore <list>
          - define new_lore "<[lore].exclude[<green>Cost: $<[item].flag[cost]>]>"
          - inventory adjust slot:<[key]> lore:<[new_lore]>