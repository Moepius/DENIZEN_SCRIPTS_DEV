# handles portals in worlds
# permission named with craftasy.denizen.portals.use_<context.area.note_name> ... last bit is name of the area
# locations named with teleportlocation_<context.area.note_name> ... last bit is name of the area

# generating area flag: /ex flag server server.worlds.portals.notedareas:<list[<cuboid[areaname]>|<cuboid[areaname]>|...]>
# adding new area: /ex flag server server.worlds.portals.notedareas:|:<cuboid[areaname]>

debug_test_portals:
    type: command
    debug: false
    name: debugportals
    description: debuggin' portals
    usage: /debugportals
    script:
        #- define areas <server.flag[server.worlds.portals.notedareas]>
        - foreach <server.flag[server.worlds.portals.notedareas].as[cuboid].note_name> as:areaname:
            - narrate format:c_debug <[areaname]>

portal_handler:
    type: world
    debug: false
    enabled: true
    events:
        # entering of portals
        ############################################
        # Spawn-Portalraum (Hortus Manium)
        on player enters area_portals_*:
        - flag <player> player.worlds.portals.isteleporting
        - run portal_checker def:<player>|craftasy.denizen.portals.use_<context.area.note_name>
        - run portal_enter_task def:<player>|teleportlocation_<context.area.note_name>
        - narrate format:c_debug "Portal betreten! <context.area.note_name>"
        on player exits area_portals_*:
        - flag <player> player.worlds.portals.isteleporting:!
        on delta time secondly:
        - define areas <server.flag[server.worlds.portals.notedareas]>
        - foreach <[areas]> as:areaname:
            - define locations <cuboid[<[areaname]>].blocks.parse[center]>
            - repeat 4:
                - playeffect effect:town_aura at:<[locations]> visibility:40
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
