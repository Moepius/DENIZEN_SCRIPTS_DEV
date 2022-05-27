# TODO: Integration in alle Scripte, die es benötigen

# permission: craftasy.denizen.task.noenter.bypass
# flags:
# notes:
# dependencies:

task_no_enter:
    type: task
    debug: debug
    definitions: taskpermission|warntext
    script:
        - if <player.has_permission[<[taskpermission]>]>:
            - stop
        - else:
            - teleport <player> <player.location.backward_flat[3]>
            - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
            - wait 2t
            - run task_barrier_show
            - ratelimit <player> 15s
            - wait 1s
            - run chatsounds_standard
            - narrate format:c_warn <[warntext]>

task_barrier_show:
    type: task
    debug: debug
    script:
        - playeffect effect:block_marker at:<player.location.forward_flat[2].relative[0,2,0]> special_data:barrier offset:0
        - playeffect effect:block_marker at:<player.location.forward_flat[2].relative[-1,3,0]> special_data:barrier offset:0
        - playeffect effect:block_marker at:<player.location.forward_flat[2].relative[1,3,0]> special_data:barrier offset:0
        - playeffect effect:block_marker at:<player.location.forward_flat[2].relative[-1,1,0]> special_data:barrier offset:0
        - playeffect effect:block_marker at:<player.location.forward_flat[2].relative[1,1,0]> special_data:barrier offset:0