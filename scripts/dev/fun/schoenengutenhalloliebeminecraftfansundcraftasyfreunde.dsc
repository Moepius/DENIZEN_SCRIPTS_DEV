fun_hallo:
    type: command
    debug: false
    name: hallo
    description: Stellt Anwender Werkzeuge und Rechte für Großprojekte zur Verfügung.
    usage: /hallo
    script:
        - if !<player.has_permission[craftasy.denizen.commands.fun.hallo]>:
            - playsound <player> sound:item_shield_block pitch:1
            - ratelimit <player> 10s
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu verwenden."
            - stop
        - else:
            - foreach <server.online_players> as:player:
                - playsound <[player]> sound:UI_TOAST_CHALLENGE_COMPLETE volume:4
                - playeffect at:<[player].location.add[0,2,0]> effect:fireworks_spark quantity:50
                - playeffect at:<[player].location.add[0,1,0]> effect:explosion_huge quantity:10
                - wait 1s
                - narrate "<&gradient[from=blue;to=green;style=rgb]><&m>--------------------------------------" targets:<[player]>
                - narrate "<&gradient[from=red;to=yellow;style=rgb]>SCHÖNEN GUTEN HALLO LIEBE MINECRAFTFANS" targets:<[player]>
                - narrate "<&gradient[from=red;to=yellow;style=rgb]>UND CRAFTASYFREUNDE!!!!!!!!!!!!" targets:<[player]>
                - narrate "<&gradient[from=black;to=white;style=rgb]><&m>--------------------------------------" targets:<[player]>
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_0 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_1 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_2 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_3 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_4 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_5 volume:4
                - playsound <[player]> sound:ITEM_GOAT_HORN_SOUND_6 volume:4