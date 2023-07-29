shriek_world_event:
    type: world
    debug: false
    events:
        on generic game event type:SHRIEK location_flagged:Shriek_menu:
            - define location <context.location>
            - define entity <context.entity>
            - if !<[entity].is_player>:
                - stop
            - if <[location].has_flag[shriek_menu.cooldown]>:
                - determine cancelled
            # If the location is on cooldown, stop the script
            - define duration <[location].flag[shriek_menu.duration].mul[20]>
            - define fade_in <[location].flag[shriek_menu.fade_in].mul[20]>
            - define fade_out <[location].flag[shriek_menu.fade_out].mul[20]>
            - define speed <[location].flag[shriek_menu.sway.speed]>
            - define height <[location].flag[shriek_menu.sway.height]>
            - define can_sway <[location].flag[shriek_menu.sway.can_sway]>
            - define cooldown <[duration].add[<[fade_in]>].add[<[fade_out]>]>
            - repeat <[location].flag[shriek_menu.text].keys.highest> as:i:
                - if <[location].flag[shriek_menu.text].get[<[i]>].is_truthy>:
                    - define text:->:<[location].flag[shriek_menu.text].get[<[i]>]>
                - else:
                    - define text:->:<element[ ]>
            - flag <[location]> shriek_menu.cooldown expire:<[cooldown]>t
            # Definitions and cooldown
            - spawn shriek_text_entity <[location].center.below[1000]> save:ent
            - define entity <entry[ent].spawned_entity>
            - wait 2t
            - if <[location].flag[shriek_menu.sway.can_sway].is_truthy>:
                - run shriek_text_sway_task def.speed:<[speed]> def.height:<[height]> def.cooldown:<[cooldown]> def.entity:<[entity]>
            # Spawns entity below 1000 blocks first because of a weird spigot issue
            # Thus, all marked shriek text locations have an internal 2 tick delay
            # To be removed once patched
            # Also checks to see if the text should be swaying
            - teleport <[entity]> <[entity].location.above[1001]>
            - adjust <[entity]> text:<[text].separated_by[<&nl>].parsed>
            - define location <[location].center.above[2]>
            # Formats the text properly

            # Fade in effect-----------
            - if <[fade_in]> > 0:
                - define fade_rate <element[1].div[<[fade_in]>].mul[230]>
                - repeat <[fade_in]> as:i:
                    - adjust <[entity]> opacity:<element[0].add[<[i].mul[<[fade_rate]>]>].round_up>
                    - wait 1t
            # Duration Effect-------------
            - wait <[duration]>t
            # Fade out effect---------
            - playsound <[location]> sound:BLOCK_AMETHYST_BLOCK_CHIME  volume:2 pitch:1
            - if <[fade_out]> > 0:
                - define fade_rate <element[1].div[<[fade_out]>].mul[255]>
                - repeat <[fade_out]> as:i:
                    - wait 1t
                    - adjust <[entity]> opacity:<element[280].sub[<[i].mul[<[fade_rate]>]>].round_down.min[255]>
            - wait 1t
            - remove <[entity]>
        on player breaks sculk_shrieker location_flagged:Shriek_menu:
            - flag <context.location> shriek_menu:!

shriek_text_sway_task:
    type: task
    debug: false
    definitions: speed|height|cooldown|entity
    script:
        - wait 2t
        - define location <[entity].location>
        - repeat <[cooldown]> as:i:
            - adjust <[entity]> interpolation_start:0t
            - adjust <[entity]> interpolation_duration:1t
            - adjust <[entity]> translation:<location[0,<[i].div[<[speed]>].sin.mul[<[height]>]>,0]>
            - wait 1t

shriek_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text:
    opacity: 25
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    interpolation_duration: 2t
    interpolation_start: 0t
    view_range: 1
    pivot: center