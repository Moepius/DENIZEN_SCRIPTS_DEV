# core tasks used by various scripts

# used to play sounds and show the player an error message
# Message via language file!
core_error:
    type: task
    debug: false
    definitions: player|message
    script:
        - narrate format:c_warn <[message]>
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:item_shield_block pitch:1

core_info:
    type: task
    definitions: player|message
    script:
        - narrate format:c_info <[message]>
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1

core_important:
    type: task
    definitions: player|message
    script:
        - narrate format:c_info <[message]>
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:entity_arrow_shoot pitch:1

core_settings:
    type: task
    definitions: player|message
    script:
        - narrate format:c_info <[message]>
        - ratelimit <[player]> 5s
        - playsound <[player]> sound:block_sculk_sensor_clicking_stop pitch:1