# TODO: config data script for drop in readiness
# TODO: Permissions, bypass usw.
# TODO: Verfeinern und anpassen


world_limit_laggitems_placements:
    type: world
    debug: false
    events:
        on player places barrel:
            - if !( <player.location.find_blocks[barrel].within[16].size> > 250 ):
                - stop
            - else:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt das Limit im Radius von 16 Blöcken für Fässer erreicht."
        on player places chest|trapped_chest:
            - if !( <player.location.find_blocks[chest|trapped_chest].within[16].size> > 100 ):
                - stop
            - else:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt das Limit im Radius von 50 Blöcken für Kisten erreicht."
        on player places hopper:
            - if !( <player.location.find_blocks[hopper].within[16].size> > 25 ):
                - stop
            - else:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt das Limit im Radius von 16 Blöcken für Trichter erreicht."
        on player places observer:
            - if !( <player.location.find_blocks[observer].within[16].size> > 15 ):
                - stop
            - else:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt das Limit im Radius von 16 Blöcken für Observer erreicht."
        on player places item_frame|glow_item_frame:
            - if !( <player.location.find_blocks[observer].within[16].size> > 50 ):
                - stop
            - else:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt das Limit im Radius von 16 Blöcken für Item Rahmen erreicht."