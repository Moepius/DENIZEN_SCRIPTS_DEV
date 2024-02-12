# obelisk script, that lets you teleport between obelisks in a world at the cost of experience points

# TODO: kleine Chance zufällig an einen unwirtlichen ort teleportiert zu werden in Hortus Manium, wo Spieler leiden: kleine Insel mit Gewitter auf dem versunkene Schiffe liegen, Nachricht "etwas stimmt nicht..."
# TODO: wenn man Obelisken oft nutzt steigt Wahrscheinlichkeit in Hortsu Manium zu landen


### eye of ender handler
# changes the location that eyes of ender point to, to the next obelisk in orbis
end_eye_handler:
    type: world
    debug: true
    enabled: true
    events:
        # TODO: integrate functionality with obelisks (point ender eye location to nearest obelisk)
        on player right clicks block with:ender_eye in:orbis:
            - spawn ENDER_SIGNAL[ender_eye_target_location=endereye_test] <player.location.add[0,1,0]>


## When the player creates a new waystone, the default display name of the waystone is: Waystone <waystone_number>
## Each waystone has a special Waystone ID that cannot be changed which is used to store the data about each waystone.
## The Waystone ID can be found in the title of the Waystone Edit GUI.

# Contains all the text and permission settings.
waystone_config:
    type: data
    debug: false
    text:
        actionbars:
            corner_1: <yellow>Eckpunkt 1<&co><white>
            corner_2: <yellow>Eckpunkt 2<&co><white>
            waystone_created: <green>Obelisk gesetzt!
        narrations:
            waystone_removed: <green>Obelisk entfernt
            discovered_waystone: <italic>Ihr habt einen Obelisk entdeckt!<&co>
            no_teleport_location_set: <red>Teleport nicht möglich<&co> Teleportziel fehlt!
            not_enough_xp: <red>Nicht genügend Erfahrungspunkte.
        lore:
            current_teleport_location: <aqua>Ziel<&co>
            teleport_location_not_set: <red>nicht gesetzt
            current_display: <aqua>Anzeigename<&co>
            current_xp_cost: <aqua>Erfahrungspunkte Kosten<&co>
            teleport_cost: <aqua>Kosten<&co><white>
            right_click_to_teleport: <aqua>Rechtsklick: Teleport
            not_enough_experience: <red>Nicht genügend Erfahrungspunkte.
    permissions:
        # Name of admin permission
        admin: denizen.admin
        waystone_tool: denizen.waystone_tool
    data:
        default_xp_cost: 5

waystone_selection_command:
    type: command
    debug: false
    name: obelisk
    description: Gives the waystone selection tool.
    usage: /obelisk
    aliases:
    - ob
    permission: <script[waystone_config].data_key[permissions.admin]><script[waystone_config].data_key[permissions.waystone_tool]>
    script:
    - give waystone_selection_tool

waystone_selection_tool:
    type: item
    debug: false
    material: blaze_rod
    display name: Obelisk Tool
    enchantments:
        # For enchantment glint
        - unbreaking:1
    mechanisms:
        hides: ALL
    lore:
    - <empty>
    - <&a>Linkslick: <&3>Eckpunkt setzen
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&c>Admin Tool

waystone_create_waystone_area:
    type: world
    debug: false
    events:
        on player left clicks block with:waystone_selection_tool:
        # Prevent double fireing
        - ratelimit <player> 1t
        - determine cancelled passively
        # If the player clicks on air, do nothing
        - stop if:<context.location.if_null[null].equals[null]>
        - if !<player.has_flag[waystone_selection_corner_one]>:
            - flag <player> waystone_selection_corner_one:<context.location>
            - actionbar "<script[waystone_config].parsed_key[text.actionbars.corner_1]> <context.location.format[bx, by, bz]>"
        - else:
            - define cuboid <player.flag[waystone_selection_corner_one].to_cuboid[<context.location>]>
            - actionbar "<script[waystone_config].parsed_key[text.actionbars.corner_2]> <context.location.format[bx, by, bz]> - <script[waystone_config].parsed_key[text.actionbars.waystone_created]>"
            - flag <player> waystone_selection_corner_one:!
            # If the player is editing the waystone zone, use the existing ID and don't create a new one.
            - if <player.has_flag[editing_waystone_zone]>:
                - define waystone_id <player.flag[editing_waystone]>
                - flag <player> editing_waystone_zone:!
            - else:
                - flag server waystones.last_id:++
                - define waystone_id waystone_<server.flag[waystones.last_id]>
                # Creates a new waystone. Default display is in titlecase with the number of its ID (for example: Waystone 5)
                - flag server waystones.data.<[waystone_id]>:<map[display=<[waystone_id].split[_].space_separated.to_titlecase>;xp_cost=<script[waystone_config].data_key[data.default_xp_cost]>]>
            # This will create a new cuboid or overwrite the existing one if the player is editing the waystone zone.
            - note <[cuboid]> as:<[waystone_id]>
            - flag <player> editing_waystone:<[waystone_id]>
            - run waystone_open_edit_gui

waystone_click_to_open_edit_gui:
    type: world
    debug: false
    events:
        on player right clicks block with:waystone_selection_tool in:waystone_*:
        - stop if:!<context.location.is_truthy>
        - flag <player> editing_waystone:<context.location.areas[waystone_*].get[1].note_name>
        - run waystone_open_edit_gui

waystone_refresh_guis:
    type: world
    debug: false
    events:
        on player closes waystone_edit_gui:
        # Allows the player to continue editing the waystone even if the inventory is closed due to editing other values.
        - if <player.has_flag[editing_waystone_zone]> || <player.has_flag[editing_waystone_display_name]> || <player.has_flag[editing_waystone_xp_cost]>:
            - flag <player> editing_waystone_display_name:!
            - flag <player> editing_waystone_xp_cost:!
            - stop
        - flag <player> editing_waystone:!

waystone_edit_gui:
    type: inventory
    debug: false
    title: Edit Waystone (<player.flag[editing_waystone]>)
    inventory: chest
    gui: true
    definitions:
      _: black_stained_glass_pane
    slots:
    - [_] [_] [waystone_edit_teleport_location_item] [waystone_edit_display_item] [waystone_edit_xp_cost_item] [waystone_edit_zone_item] [waystone_remove_item] [_] [_]

# Adjusts all the lore for the edit GUI to have current values shown.
waystone_open_edit_gui:
    type: task
    debug: false
    script:
    - define inv <inventory[waystone_edit_gui]>
    - define waystone_data <server.flag[waystones.data.<player.flag[editing_waystone]>]>
    - inventory adjust d:<[inv]> slot:3 lore:<script[waystone_config].parsed_key[text.lore.current_teleport_location]>|<[waystone_data].get[teleport_loc].simple.if_null[<script[waystone_config].parsed_key[text.lore.teleport_location_not_set]>]>
    - inventory adjust d:<[inv]> slot:4 lore:<script[waystone_config].parsed_key[text.lore.current_display]>|<[waystone_data].get[display]>
    - inventory adjust d:<[inv]> slot:5 lore:<script[waystone_config].parsed_key[text.lore.current_xp_cost]>|<[waystone_data].get[xp_cost]>
    - inventory open d:<[inv]>

waystone_edit_display_item:
    type: item
    debug: false
    material: oak_sign
    display name: Edit Waystone Display Name

waystone_edit_xp_cost_item:
    type: item
    debug: false
    material: slime_ball
    display name: Edit Waystone Exp. Cost

waystone_edit_teleport_location_item:
    type: item
    debug: false
    material: compass
    display name: Edit Waystone Teleport Location

waystone_edit_zone_item:
    type: item
    debug: false
    material: blaze_rod
    display name: Edit Waystone Zone

waystone_remove_item:
    type: item
    debug: false
    material: barrier
    display name: <white><italic>Remove Waystone

waystone_edit_gui_events:
    type: world
    debug: false
    events:
        # Open fake sign edit interface to input display name
        on player clicks waystone_edit_display_item in waystone_edit_gui:
        - flag <player> editing_waystone_display_name
        - adjust <player> edit_sign
        on player changes sign flagged:editing_waystone_display_name:
        - if <context.new.get[1].length> != 0:
            - flag server waystones.data.<player.flag[editing_waystone]>.display:<context.new.get[1]>
        - run waystone_open_edit_gui
        # Open fake sign edit interface to input experiance cost
        on player clicks waystone_edit_xp_cost_item in waystone_edit_gui:
        - flag <player> editing_waystone_xp_cost
        - adjust <player> edit_sign
        on player changes sign flagged:editing_waystone_xp_cost:
        - if <context.new.get[1].length> != 0:
            - flag server waystones.data.<player.flag[editing_waystone]>.xp_cost:<context.new.get[1]>
        - run waystone_open_edit_gui
        on player clicks waystone_edit_teleport_location_item in waystone_edit_gui:
        - flag server waystones.data.<player.flag[editing_waystone]>.teleport_loc:<player.location>
        - run waystone_open_edit_gui
        on player clicks waystone_edit_zone_item in waystone_edit_gui:
        - flag <player> editing_waystone_zone
        - inventory close
        on player clicks waystone_remove_item in waystone_edit_gui:
        - define id <player.flag[editing_waystone]>
        - note remove as:<[id]>
        - flag server waystones.data.<[id]>:!
        # If a player has discovered this waystone, remove it from their list of discovered waystones.
        - foreach <server.players_flagged[discovered_waystones]> as:player:
            - if <[player].flag[discovered_waystones].contains[<[id]>]>:
                - flag <[player]> discovered_waystones:<-:<[id]>
        - narrate <script[waystone_config].parsed_key[text.narrations.waystone_removed]>
        - inventory close

waystone_player_discovers_new_waystone:
    type: world
    debug: false
    events:
        on player enters waystone_*:
        - stop if:<player.flag[discovered_waystones].if_null[<list[]>].contains[<context.area.note_name>]>
        - flag <player> discovered_waystones:->:<context.area.note_name>
        - narrate "<script[waystone_config].parsed_key[text.narrations.discovered_waystone]> <server.flag[waystones.data.<context.area.note_name>].get[display]>"

waystone_list_of_waystones_gui:
    type: inventory
    debug: false
    inventory: chest
    title: Discovered Waystones
    gui: true
    size: 45
    procedural items:
    - define result <list[]>
    - define waystones <list[]>
    # Check if player is admin.
    - if <player.proc[waystone_has_admin_permission]>:
        - define waystones:<server.flag[waystones.data].keys>
    - else:
        - define waystones:<player.flag[discovered_waystones]>
    # Pagination: separate waystones into separate pages.
    # Each page can hold a total of 35 waystone items.
    - define pages <map[]>
    - define page 1
    - foreach <[waystones]> as:i:
        - if <[pages.<[page]>].size||0> > 35:
            - define page:++
        - define pages.<[page]>:->:<[i]>
    # Loop through the items on each page.
    - foreach <[pages].get[<player.flag[waystones_page]||1>]> as:name:
        - define data <server.flag[waystones.data.<[name]>]>
        # Lore and display name data
        - definemap itemdata:
            display: <[data].get[display]>
            lore:
                - <script[waystone_config].parsed_key[text.lore.teleport_cost]> <[data].get[xp_cost]>
                - <script[waystone_config].parsed_key[text.lore.right_click_to_teleport]>
        - if <player.calculate_xp> < <[data].get[xp_cost]> && !<player.proc[waystone_has_admin_permission]>:
            - define lore <[itemdata.lore]>
            # If the player is unable to teleport, insert new lore that says they are unable to.
            - define lore[2]:<script[waystone_config].parsed_key[text.lore.not_enough_experience]>
            - define itemdata.lore:<[lore]>
        # Waystone item.
        - define item <item[blackstone].with_map[<[itemdata]>]>
        - define result:->:<[item].with_flag[waystone_to_teleport_to:<[name]>]>
    # Add next page button if not on last page.
    - if <player.flag[waystones_page]> < <[pages].size>:
        - define result <[result].pad_right[45].with[black_stained_glass_pane]>
        - define result[45]:waystone_next_page_paginator
    # Add back page button if on not on first page
    - if <player.flag[waystones_page]> > 1:
        - define result <[result].pad_right[45].with[black_stained_glass_pane]>
        - define result[37]:waystone_previous_page_paginator
    - determine <[result]>

waystone_list_pagination:
    type: world
    debug: false
    events:
        on player clicks waystone_next_page_paginator in waystone_list_of_waystones_gui:
        - flag <player> waystones_page:++
        - flag <player> moving_page
        - inventory open d:waystone_list_of_waystones_gui
        - flag <player> moving_page:!
        on player clicks waystone_previous_page_paginator in waystone_list_of_waystones_gui:
        - flag <player> waystones_page:--
        - flag <player> moving_page
        - inventory open d:waystone_list_of_waystones_gui
        - flag <player> moving_page:!
        on player closes waystone_list_of_waystones_gui flagged:!moving_page:
        - flag <player> waystones_page:0

waystone_previous_page_paginator:
    type: item
    debug: false
    material: spectral_arrow
    display name: Previous Page

waystone_next_page_paginator:
    type: item
    debug: false
    material: spectral_arrow
    display name: Next Page

waystone_player_wants_to_teleport:
    type: world
    debug: false
    events:
        on player right clicks block in:waystone* with:!waystone_selection_tool:
        - flag <player> waystones_page:1
        - inventory open d:waystone_list_of_waystones_gui
        on player right clicks item_flagged:waystone_to_teleport_to in waystone_list_of_waystones_gui:
        - define data <server.flag[waystones.data.<context.item.flag[waystone_to_teleport_to]>]>
        # Check if teleport location is set.
        - if <[data].get[teleport_loc].if_null[null]> == null:
            - narrate <script[waystone_config].parsed_key[text.narrations.no_teleport_location_set]>
            - inventory close
            - stop
        # If player XP is too low AND the player is not an admin, don't teleport.
        # If the player is an admin, the if check will fail and allow them to teleport without an XP restriction.
        - if <player.calculate_xp> < <[data].get[xp_cost]> && !<player.proc[waystone_has_admin_permission]>:
            - narrate <script[waystone_config].parsed_key[text.narrations.not_enough_xp]>
            - playsound <player> sound:item_shield_block
            - inventory close
            - stop
        - teleport <[data].get[teleport_loc]>
        # Take XP if the player is not an admin
        - experience take <[data].get[xp_cost]> if:!<player.proc[waystone_has_admin_permission]>

waystone_has_admin_permission:
    type: procedure
    debug: false
    definitions: player
    script:
        - determine <[player].has_permission[<script[waystone_config].data_key[permissions.admin]>]>

waystone_show_particles:
    type: world
    debug: false
    events:
        on delta time secondly every:4:
        # Loop through all the waystones and plays the soul particle effect at each one.
        # If there are no waystones, the list returns empty and the foreach loop won't fire.
        - foreach <server.flag[waystones.data].if_null[<list[]>]> key:name:
            # Finds players to make sure that the chunk is loaded
            - if <cuboid[<[name]>].center.find_players_within[50].any>:
                - repeat 15:
                    - playeffect effect:soul at:<cuboid[<[name]>].random>