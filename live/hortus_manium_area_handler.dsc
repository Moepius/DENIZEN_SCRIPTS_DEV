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
        # ego area: area on hortus manium surface where players can interact with the ego npc to adjust skills and character
        on player enters area_ego:
            - flag <player> player.worlds.area.in_area_ego
        on player exits area_ego:
            - flag <player> player.worlds.area.in_area_ego:!
        # mons manium: surface of hortus manium ... spawn location: location_mons_manium_tempel
        on player enters area_mons_manium:
            - wait 2s
            - ratelimit <player> 10m
            - playsound <player> sound:block_bell_resonate pitch:0.8
            - playsound <player> sound:block_beacon_power_select pitch:0.2
            - title "title:<&6>Hortus Manium" "subtitle:<&f>Mons Manium" stay:3s targets:<player>
        on player enters area_hortusmanium_zentrum:
            - flag <player> player.worlds.area.in_hortusmanium_zentrum
        after player exits area_hortusmanium_zentrum:
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
            - define Spieler <server.online_players_flagged[player.worlds.area.in_area_ego]>
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

