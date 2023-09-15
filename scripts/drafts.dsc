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


############## QUESTING DIALOGUE draft ##################

# nutzt text displays, die neben dem NPC erscheinen zur Darstelllung von Dialog mit NPCs
# Siehe Discord Thread: https://discord.com/channels/315163488085475337/1149977872996507679

# speaker:
#   title (string)
#   text (string)
# options:
#   - text (string)
#     click (task)

tickquests_dialogue_update_text_task:
    type: task
    definitions: dialogue|dialogue_entity|selected[The selected option index.]
    script:
    - define title <[dialogue.speaker.title]>
    - define text <[dialogue.speaker.text]>
    - define lines <list>
    # TITLE
    - define lines:->:<[title]>
    # TEXT
    - define lines:->:<empty>
    - define lines:->:<&[base]><[text]>

    - define text <[lines].separated_by[<n>]>
    - define line_width <[dialogue_entity].line_width>
    - define height <[text].split_lines_by_width[<[line_width]>].split[<n>].size>

    # OPTIONS
    - define lines:->:<empty>
    - define line_height_accumulated 0
    - define line_heights <list>
    - foreach <[dialogue.options]> as:opt:
        - if <[selected].if_null[0]> == <[loop_index]>:
            - define lines:->:<[opt.text].custom_color[emphasis].bold>
        - else:
            - define lines:->:<[opt.text].color[white]>
        - define option_split_line <[opt.text].split_lines_by_width[<[line_width]>].split[<n>].size>
        - define line_height_accumulated:+:<[option_split_line]>
        - define line_height <[dialogue.options].size.add[1].sub[<[line_height_accumulated]>]>
        - define line_heights:->:<[line_height]>
        - announce "line height of '<[opt.text]>' is <[line_height]>"

    - define text <[lines].separated_by[<n>]>
    - adjust <[dialogue_entity]> text:<[text]>
    - flag <[dialogue_entity]> tickquests.dialogue:<[dialogue]>
    - flag <[dialogue_entity]> tickquests.line_heights:<[line_heights]>
    - flag <[dialogue_entity]> tickquests.selected:<[selected]>

tickquests_dialogue_create_task:
    type: task
    definitions: dialogue|loc|dialogue_entity|players
    description: Creates a dialogue entity at the given location and shows it to the given players. Creates interaction entities for each option.
    script:
    - if !<[dialogue_entity].exists>:
        - fakespawn tickquests_dialogue_text_display <[loc]> save:text players:<[players]>
        - define dialogue_entity <entry[text].faked_entity>
    - define loc <[dialogue_entity].location>

    - run tickquests_dialogue_update_text_task def.dialogue:<[dialogue]> def.dialogue_entity:<[dialogue_entity]>
    - define base_height <[dialogue_entity].scale.y.mul[0.25]>
    - foreach <[dialogue_entity].flag[tickquests.line_heights]> as:lh:
        - spawn tickquests_dialogue_hover_entity <[loc].above[<[base_height].mul[<[lh].sub[1]>]>]> save:opt_entity
        - define opt_entity <entry[opt_entity].spawned_entity>
        - adjust <[opt_entity]> height:<[base_height]>
        - adjust <[opt_entity]> width:2

tickquests_dialogue_hover_option:
    type: task
    definitions: dialogue_entity|opt_index
    script:
    - define dialogue <[dialogue_entity].flag[tickquests.dialogue]>
    - run tickquests_dialogue_update_text_task def.dialogue:<[dialogue]> def.dialogue_entity:<[dialogue_entity]> def.selected:<[opt_index]>

tickquests_dialogue_text_display:
    type: entity
    entity_type: text_display
    mechanisms:
        background_color: black
        pivot: center
        display: left
        scale: 0.7,0.7,0.7
        line_width: 200
        see_through: true

tickquests_dialogue_hover_entity:
    type: entity
    entity_type: interaction

tickquests_sample_dialogue:
    type: data
    d:
        speaker:
            title: James
            text: Hello, I'm <element[James].custom_color[emphasis]>. This is a sample dialogue.
        options: <list[<map[text=Opt 1]>].include_single[<map[text=Opt 2]>]>
