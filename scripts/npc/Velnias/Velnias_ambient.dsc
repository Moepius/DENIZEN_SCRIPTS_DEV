# areas: area_note_velnias, area_note_velniascube
# location:velnias_location
# Zeigt Spieler Partikel und Sounds in der Nähe von Velnias

velniasambient:
    type: world
    debug: false
    events:
        on player enters area_note_velnias:
            - flag <player> player_in_spawnwelt_velnias
        on player enters area_note_velniascube:
            - ratelimit <player> 30s
            - actionbar format:actionbarStatus "Euch wird plötzlich kalt."
            - wait 2s
            - adjust <player> freeze_duration:12s
        on player exits area_note_velnias:
            - flag <player> player_in_spawnwelt_velnias:!
        on system time secondly every:9:
            - define Spieler <server.online_players_flagged[player_in_spawnwelt_velnias]>
            - random:
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,2,0]> quantity:15 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:PARTICLE_SOUL_ESCAPE
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,2,1]> quantity:10 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:PARTICLE_SOUL_ESCAPE
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[1,2,0]> quantity:6 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:ENTITY_STRIDER_AMBIENT
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,3,1]> quantity:15 targets:<[Spieler]>
                        - playsound <[Spieler]> sound:PARTICLE_SOUL_ESCAPE
        on system time secondly:
            - define Spieler <server.online_players_flagged[player_in_spawnwelt_velnias]>
            - random:
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,2,0]> quantity:2 targets:<[Spieler]>
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,2,0]> quantity:1 targets:<[Spieler]>
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[0,2,0]> quantity:4 targets:<[Spieler]>
                - repeat 1:
                    - foreach <[Spieler]> as:Spieler:
                        - playeffect effect:SOUL at:<location[velnias_location].add[1,3,0]> quantity:5 targets:<[Spieler]>