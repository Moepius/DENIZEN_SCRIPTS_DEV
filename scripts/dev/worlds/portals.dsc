# handles portals in worlds
# permission named with craftasy.denizen.portals.use_<context.area.note_name> ... last bit is name of the area
# locations named with teleportlocation_<context.area.note_name> ... last bit is name of the area, example: teleportlocation_area_portals_hortus-avarus

# generating area flag: /ex flag server server.worlds.portals.notedareas:<list[<cuboid[areaname]>|<cuboid[areaname]>|...]>
# adding new area: /ex flag server server.worlds.portals.notedareas:|:<cuboid[areaname]>
# remove area: /ex flag server server.worlds.portals.notedareas:<-:<cuboid[areaname]>
# /ex note <player.location> as:teleportlocation_
# areas: area_portals_hortus-avarus, area_portals_avarus-hortus, area_portals_hortus-zeitkapsel, area_portals_zeitkapsel-hortus, area_portals_hortus-orbis, area_portals_orbis-hortus
# area_portals_hortus-arboretum, area_portals_arboretum-hortus
# locations:

debug_test_portals:
    type: command
    debug: false
    name: debugportals
    description: debuggin' portals
    usage: /debugportals
    script:
        #- define areas <server.flag[server.worlds.portals.notedareas]>
        - foreach <server.flag[server.worlds.portals.notedareas]> as:areaname:
            - narrate format:c_debug "<[areaname]>, "

portal_creator:
    type: command
    debug: true
    name: portal
    description: create or change a portal
    permission: craftasy.denizen.command.portal
    usage: /portal
    aliases:
    - po
    tab completions:
        1: <list[tool|create|edit]>
    script:
        # TODO: put origin and destination world names in the description/item lore
        - if <context.args.size> >= 1:
            - define argument <context.args.first>
            - if <[argument]> not in <list[tool|create|edit]>:
                - run core_error "def:<player>|Gültige Parameter: <&a>tool<&c>, <&a>create<&c>, <&a>edit <&c>oder <&a>remove<&c>."
                - stop
        - if <[argument]> == tool:
            - narrate "tool, select cuboid"
        - else if <[argument]> == create:
            - narrate "create, name the portal"
        - else if <[argument]> == edit:
            - narrate "edit, open menu"

portal_menu:
    type: inventory
    debug: true
    inventory: chest
    title: <&f><&l>Portale Einstellungen
    gui: true
    data:
        plants_lore_12:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot12].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
    definitions:
        x: <item[gui_filler]>
        page: <item[portals_pager]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [gui_close] [x] [x] [x] [x] [x] [x] [x] [page]

portal_handler:
    type: world
    debug: false
    enabled: true
    events:
        # entering of portals
        ############################################
        # Spawn-Portalraum (Hortus Manium)
        on player enters area_portals_*:
        # remove 1 Seelenheil from player
        # TODO: permission check, no removal of seelenheil if no permission
        # TODO: if check, is target location in same world? no: remove 1 seelenheil, yes: do nothing
        - flag <player> player.worlds.portals.isteleporting
        - run portal_checker def:<player>|craftasy.denizen.portals.use_<context.area.note_name>
        - run portal_enter_task def:<player>|teleportlocation_<context.area.note_name>
        #- narrate format:c_debug "Portal betreten! <context.area.note_name>"
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

item_portal_selector:
    type: item
    material: blaze_rod
    display name: <&a><&l>Portal Selector
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&a>Wählt mit Rechtsklick und
    - <&a>Linksklick Eckpunkte für
    - <&a>die Portalzone aus.
    - <empty>
    - <&a>Mit Schleichen + Rechtsklick
    - <&a>wählt Ihr das Ziel aus.
    - <empty>
    - <&f><&m>---------------------------
    - <&7>Zutat<&co> <&c><&chr[274C]> <&7>Herstellbar<&co> <&c><&chr[274C]>
    - <&f><&m>---------------------------
    - <&c>Admin

portal_pager:
    type: item
    material: blaze_rod


