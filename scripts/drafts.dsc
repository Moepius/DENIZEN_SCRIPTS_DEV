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