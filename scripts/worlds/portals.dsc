# handles portals in worlds

portal_handler:
    type: world
    debug: false
    enabled: true
    events:
        # entering of portals
        ############################################
        # Spawn-Portalraum (Hortus Manium)
        on player enters area_portals_spawn-portalraum:
        - run portal_checker def:<player>|craftasy.denizen.portals.use_spawn_portalraum
        - flag <player> player.worlds.portals.isteleporting
        - narrate format:c_debug "warp test"
        - run portal_enter_task def:<player>|location_portals_spawn-portalraum
        on player enters area_portals_portalraum-spawn:
        - run portal_checker def:<player>|craftasy.denizen.portals.use_portalraum-spawn
        - flag <player> player.worlds.portals.isteleporting
        - narrate format:c_debug "warp test"
        - run portal_enter_task def:<player>|location_portals_portalraum-spawn
        on delta time secondly:
        - define locations <cuboid[area_portals_spawn-portalraum].blocks.parse[center]>
        - repeat 4:
            - playeffect effect:town_aura at:<[locations]> visibility:50
            - wait 5t

portal_checker:
    type: task
    debug: false
    definitions: player|permission
    script:
        - if !<[player].has_permission[<[permission]>]>:
            - run task_no_enter "def:<[player]>|<[permission]>|Ihr könnt dieses Portal nicht benutzen!"


portal_enter_task:
    type: task
    debug: false
    definitions: player|destination
    script:
        - cast blindness duration:2s hide_particles no_ambient no_icon <[player]>
        - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
        - playeffect effect:SPELL_WITCH at:<[player].location> visibility:500 quantity:120 offset:1.5
        - teleport <[player]> <[destination]>
