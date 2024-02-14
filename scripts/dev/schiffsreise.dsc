# TODO: Dialog: "zeigt mir Eure Reiseberechtigung"
# TODO: wenn Spieler Boot betritt ohne Reiseberechtigung: "runter von meinem Schiff + Teleport", bei WIederholung, Schaden


# area_moraira_schiff-terra-nova
# teleportlocation_schiff-terra-nova-kick

schiffe_handler:
    type: world
    enabled: true
    debug: false
    events:
        after player enters area_moraira_schiff-terra-nova flagged:!player.terra_nova.reiseberechtigung:
            - wait 2s
            - run chatsounds_standard def:<player>
            - narrate format:npc_human "Runter von meinem Schiff!"
            - cast blindness duration:1s no_icon no_ambient no_clear
            - playsound <player> sound:ENTITY_VILLAGER_NO pitch:0.2
            - teleport <player> teleportlocation_schiff-terra-nova-kick