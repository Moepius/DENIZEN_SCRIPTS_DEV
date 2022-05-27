# plays some sounds and sends a formatted message to the player if an action he tries to make is not allowed


task_player_error:
    type: task
    definitions: message | player | location | block_data
    script:
        - playsound <[player]> sound:item_shield_block pitch:1
        - playeffect effect:block_crack at:<[location]> visibility:500 special_data:<[block_data]> quantity:5
        - ratelimit <[player]> 10s
        - narrate format:c_warn <[message]> targets:<[player]>