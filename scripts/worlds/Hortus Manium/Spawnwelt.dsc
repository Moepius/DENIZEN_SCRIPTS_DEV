# spielt sounds ab, während ein Spieler in der Spawnwelt ist
# notes: area_note_spawnwelt_brunnen, area_note_spawnwelt, area_note_portalraum-dungeon, area_note_spawnwelt_zentrum
# TODO: Schaden/Effekt/Malus wenn Spieler in der Nähe des Einschlags
# TODO: Bei Betreten des Lochs, statt Portal, Denizen Partikel und Schaden Event o.ä.
# TODO: flags etc. anpassen
# TODO: portal areas hinzufügen + Mechaniken

hideplayers_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player enters area_hortusmanium:
        - flag <player> player.worlds.area.in_hortusmanium
        ## Remove debug, when done
        - narrate format:c_debug "Event: player enters area_hortusmanium, Mechanism: hide_from_players, gesetzt."
        - adjust <player> hide_from_players

spawnwelt:
    type: world
    debug: false
    enabled: false
    events:
    #flag players for entering/leaving the areas
        on player enters area_note_portalraum-dungeon:
            - flag <player> player_in_area_note_portalraum-dungeon
        on player exits area_note_portalraum-dungeon:
            - flag <player> player_in_area_note_portalraum-dungeon:!
        on player enters area_note_spawnwelt_zentrum:
            - flag <player> player_in_area_note_spawnwelt_zentrum
        on player exits area_note_spawnwelt_zentrum:
            - flag <player> player_in_area_note_spawnwelt_zentrum:!
        # flag player for entering portal room
        on player enters area_note_spawnwelt:
            - flag <player> player_in_area_note_spawnwelt
            - playsound <player> sound:AMBIENT_SOUL_SAND_VALLEY_LOOP
        on player exits area_note_spawnwelt:
            - flag <player> player_in_area_note_spawnwelt:!
        on system time secondly:
            - define Spieler <server.online_players_flagged[player_in_area_note_portalraum-dungeon]>
            - foreach <[Spieler]>:
                - playsound <[Spieler]> sound:BLOCK_CONDUIT_AMBIENT pitch:1
        # ambient sound for portal room
        on system time secondly every:10:
            - define Spieler <server.online_players_flagged[player_in_area_note_spawnwelt]>
            - random:
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playsound <[Spieler]> sound:AMBIENT_SOUL_SAND_VALLEY_LOOP
        # ambient sound for portal room
        on system time secondly every:20:
            - define Spieler <server.online_players_flagged[player_in_area_note_spawnwelt]>
            - repeat 1:
                - foreach <[Spieler]> as:Spieler:
                    - playeffect effect:SOUL at:<location[velnias_location].add[1,2,0]> quantity:6 targets:<[Spieler]>
                    - playsound <[Spieler]> sound:ambient_nether_wastes_mood volume:0.5
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,3,1]> quantity:15 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:ambient_soul_sand_valley_mood
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,3,1]> quantity:8 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:ambient_soul_sand_valley_additions
                - stop
        # play some effect at the portalroom center
        on system time secondly every:25:
            - define Spieler <server.online_players_flagged[player_in_area_note_spawnwelt_zentrum]>
            - random:
                - repeat 1:
                    - playsound <[Spieler]> sound:entity_evoker_prepare_attack pitch:0.1
                    - playeffect effect:soul_fire_flame at:<location[location_hortusmanium_portalraum_zentrum].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:1 targets:<[Spieler]>
                    - wait 0.9s
                    - strike no_damage <location[location_hortusmanium_portalraum_zentrum].add[0,-50,0]>
                    - playeffect effect:smoke at:<location[location_hortusmanium_portalraum_zentrum].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:5 targets:<[Spieler]>
                    - playsound <[Spieler]> sound:entity_illusioner_prepare_blindness
                    - wait 0.7s
                    - playeffect effect:SOUL at:<location[location_hortusmanium_portalraum_zentrum].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:2 targets:<[Spieler]>
                    - playsound <[Spieler]> sound:particle_soul_escape volume:5
                    - wait 2t
                    - playsound <[Spieler]> sound:particle_soul_escape volume:5
                    - wait 1s
                    - playsound <[Spieler]> sound:ambient_soul_sand_valley_mood volume:0.5
                - repeat 1:
                    - stop
           
