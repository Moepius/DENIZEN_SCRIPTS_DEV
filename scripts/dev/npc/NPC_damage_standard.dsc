npc_damage_standard:
    type: assignment
    debug: false
    actions:
        on assignment:
        - trigger name:damage state:true
    interact scripts:
    - npc_damage_standard_interact

npc_damage_standard_interact:
    type: interact
    debug: false
    steps:
        1:
            damage trigger:
                script:
                    - playsound <player> sound:ENTITY_PLAYER_HURT
                    - playeffect effect:villager_angry at:<npc.location.add[0,2,0]> quantity:5