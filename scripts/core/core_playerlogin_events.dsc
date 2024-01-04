
core_login_handler:
    type: world
    debug: false
    enabled: true
    events:
        on player joins:
        - determine none passively
        ### playeffect at hortusmanium zentrum
        # TODO: exclude players who have guest rank from damage
        - define player <server.online_players_flagged[player.worlds.area.in_hortusmanium_zentrum]>
        - define damagetargets <location[location_hortusmanium_zentrum_seelenschlund].find_entities.within[14]>
        - foreach <[player]> as:target:
            - narrate format:c_debug "Hortus Manium Blitz ausgelöst."
            - playsound <[target]> sound:entity_evoker_prepare_attack pitch:0.1
            - playeffect effect:soul_fire_flame at:<location[location_hortusmanium_zentrum_seelenschlund].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:1
        - wait 0.9s
        - foreach <list[1].pad_right[550]>:
            - playeffect effect:SOUL at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 targets:<[player]>
        - foreach <list[1].pad_right[550]>:
            - playeffect effect:smoke at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1
        - playeffect effect:smoke at:<location[location_hortusmanium_zentrum_seelenschlund].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:5 targets:<[player]>
        - foreach <[player]> as:target:
            - adjust <[damagetargets]> freeze_duration:12s
            - playsound <[target]> sound:entity_illusioner_prepare_blindness
            - wait 0.7s
            - hurt 3 <[damagetargets]>
            - playeffect effect:SOUL at:<location[location_hortusmanium_zentrum_seelenschlund].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:2 targets:<[player]>
            - playsound <[target]> sound:particle_soul_escape volume:5
            - wait 2t
            - playsound <[target]> sound:particle_soul_escape volume:5
            - wait 1s
            - hurt 4 <[damagetargets]>
            - playsound <[target]> sound:ambient_soul_sand_valley_mood volume:0.5
        after player joins:
        # initial flagging on join
        # flag last login timestamp
        - flag <player> player.core.lastlogin.timestamp:<time[<util.time_now>]>
        # player joining announcment
        - foreach <server.online_players.exclude[<player>]>:
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:1.5
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:1.5
            - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>betritt den Server."
        # Spielern begrüßen, je nach Tagsezeit
        # ABend/Tag/Morgen wird in event festgelegt siehe weiter unten
        - narrate format:c_info targets:<player> "Guten <server.flag[timeofday]> <&a><player.name><&b>."
        #TODO readd MOTD
        ###- wait 3s
        ###- run task_motd def:<player>
        on player quits:
        - determine none passively
        after player quits:
        # initial flagging on quitting
        # flag last quit timestamp
        - flag <player> player.core.lastquit.timestamp:<time[<util.time_now>]>
        # player quitting announcment
        - foreach <server.online_players.exclude[<player>]>:
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:0.2
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:0.2
            - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>hat den Server verlassen."
        on system time 04:00:
            - flag server timeofday:Morgen
        on system time 11:00:
            - flag server timeofday:Tag
        on system time 19:00:
            - flag server timeofday:Abend
        on system time 12:02:
            - narrate test!
            - flag server timeofday:test

task_motd:
    type: task
    debug: false
    definitions: player
    script:
    # TODO: add later, && <player.has_permission[craftasy.denizen.task.motd]> && !<[player].has_flag[player.flag.no_motd]>
        - if !<[player].has_flag[motd_gelesen]>:
            - run chatsounds_standard def:<[player]>
            - narrate format:headerMitText "Wichtige Information"
            - narrate <empty>
            - narrate "<&3>Es wird aktiv am Server gearbeitet."
            - narrate "<&7>Aktuell kein technischer Support und"
            - narrate "<&7>Verlust von Bau-/ Fortschritten möglich!"
            - narrate <empty>
            - narrate format:footerOhneText <empty>
            - flag <[player]> motd_gelesen expire:12h
        - else:
            - stop