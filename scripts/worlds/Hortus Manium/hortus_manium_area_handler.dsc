# spielt sounds ab, während ein Spieler in der Spawnwelt ist
# notes: area_hortusmanium_brunnen, area_hortusmanium, area_portalraum_dungeon, area_hortusmanium_zentrum
# TODO: Schaden/Effekt/Malus wenn Spieler in der Nähe des Einschlags
# TODO: Bei Betreten des Lochs, statt Portal, Denizen Partikel und Schaden Event o.ä.
# TODO: flags etc. anpassen
# TODO: portal areas hinzufügen + Mechaniken


hortusmanium_handler:
    type: world
    debug: false
    enabled: true
    events:
        #flag players for entering/leaving the areas
        on player enters area_portalraum_dungeon:
            - flag <player> player.worlds.area.in_portalraum_dungeoneingang
        on player exits area_portalraum_dungeon:
            - flag <player> player.worlds.area.in_portalraum_dungeoneingang:!
        on player enters area_hortusmanium_zentrum:
            - narrate format:c_debug "player enters area_hortusmanium_zentrum"
            - flag <player> player.worlds.area.in_hortusmanium_zentrum
        after player exits area_hortusmanium_zentrum:
            - narrate format:c_debug "player exits area_hortusmanium_zentrum"
            - flag <player> player.worlds.area.in_hortusmanium_zentrum:!
        # flag player for entering portal room
        on player enters area_hortusmanium:
            - flag <player> player.worlds.area.in_hortusmanium
            - adjust <player> hide_from_players
            - playsound <player> sound:AMBIENT_SOUL_SAND_VALLEY_LOOP
        on player exits area_hortusmanium:
            - flag <player> player.worlds.area.in_hortusmanium:!
            - adjust <player> show_to_players
        on player enters area_hortusmanium_zentrum_seelenschlund:
            - wait 0.5s
            - cast slow_falling duration:10h hide_particles no_ambient no_icon <player>
            - cast darkness duration:10h hide_particles no_ambient no_icon <player>
        on player exits area_hortusmanium_zentrum_seelenschlund:
            - cast slow_falling remove <player>
            - cast darkness remove <player>
        on system time secondly:
            # sounds dungeoneingang
            - define Spieler <server.online_players_flagged[player.worlds.area.in_portalraum_dungeoneingang]>
            - foreach <[Spieler]>:
                - playsound <[Spieler]> sound:BLOCK_CONDUIT_AMBIENT pitch:1
            # particles Hortus Manium
            - foreach <list[1].pad_right[2000]>:
                - playeffect effect:white_ash at:<cuboid[area_hortusmanium].random> visibility:50 quantity:10
            - foreach <list[1].pad_right[1500]>:
                - playeffect effect:sculk_soul at:<cuboid[area_hortusmanium].random> visibility:50 quantity:1 velocity:0,0.1,0
            - foreach <list[1].pad_right[800]>:
                - playeffect effect:SOUL at:<cuboid[area_hortusmanium].random> visibility:50 quantity:1 velocity:0,0.1,0
            # particles seelenschlund
            - foreach <list[1].pad_right[100]>:
                - playeffect effect:SOUL at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,0.1,0
            - foreach <list[1].pad_right[80]>:
                - playeffect effect:sculk_soul at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,0.1,0
            - foreach <list[1].pad_right[100]>:
                - playeffect effect:smoke at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:2
            - foreach <list[1].pad_right[50]>:
                - playeffect effect:soul_fire_flame at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,5,0
            - wait 0.5s
            - foreach <list[1].pad_right[50]>:
                - playeffect effect:soul_fire_flame at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,5,0
            - foreach <list[1].pad_right[50]>:
                - playeffect effect:soul_fire_flame at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,3,0
            - wait 0.2s
            - foreach <list[1].pad_right[50]>:
                - playeffect effect:soul_fire_flame at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:1 velocity:0,1,0
        on system time secondly every:5:
            - foreach <list[1].pad_right[5]>:
                - playeffect effect:SOUL at:<cuboid[area_hortusmanium_zentrum_seelenschlund].random> visibility:100 quantity:10
        # ambient sound for portal room
        on system time secondly every:10:
            - define Spieler <server.online_players_flagged[player.worlds.area.in_hortusmanium]>
            - random:
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playsound <[Spieler]> sound:AMBIENT_SOUL_SAND_VALLEY_LOOP
        # ambient sound for portal room
        on system time secondly every:20:
            - define player <server.online_players_flagged[player.worlds.area.in_hortusmanium]>
            - repeat 1:
                - foreach <[player]> as:player:
                    - playeffect effect:SOUL at:<location[velnias_location].add[1,2,0]> quantity:6 targets:<[player]>
                    - playsound <[player]> sound:ambient_nether_wastes_mood volume:0.5
                - repeat 1:
                    - foreach <[player]> as:player:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,3,1]> quantity:15 targets:<[player]>
                        - playsound <[player]> sound:ambient_soul_sand_valley_mood
                - repeat 1:
                    - foreach <[player]> as:player:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,3,1]> quantity:8 targets:<[player]>
                        - playsound <[player]> sound:ambient_soul_sand_valley_additions
                - stop
        # play some effect at the portalroom center
        on system time secondly every:120:
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
                - hurt <[damagetargets]> 3
                - playeffect effect:SOUL at:<location[location_hortusmanium_zentrum_seelenschlund].add[0,-11,0].points_around_y[radius=10;points=300]> visibility:500 quantity:2 targets:<[player]>
                - playsound <[target]> sound:particle_soul_escape volume:5
                - wait 2t
                - playsound <[target]> sound:particle_soul_escape volume:5
                - wait 1s
                - hurt <[damagetargets]> 4
                - playsound <[target]> sound:ambient_soul_sand_valley_mood volume:0.5

