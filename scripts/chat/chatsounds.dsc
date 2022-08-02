#TODO: set up a definition for targeting, instead of <player> tag
#TODO: In Task Ordner verschieben und umbenennen

chatsounds_standard:
    type: task
    definitions: player
    script:
        - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1

chatsounds_important:
    type: task
    definitions: player
    script:
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:entity_arrow_shoot pitch:1

chatsounds_error:
    type: task
    definitions: player
    script:
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:item_shield_block pitch:1

chatsounds_settings:
    type: task
    definitions: player
    script:
        - ratelimit <[player]> 10s
        - playsound <[player]> sound:block_sculk_sensor_clicking_stop volume:1 pitch:1