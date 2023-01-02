# Teleportanker
# Author: Moepius
# Version: 0.1.5
#
# flags: teleportanker_1_location_<[playeruuid]>, teleportanker_2_location_<[playeruuid]>, teleportanker_3_warnung, teleportanker_uuid
# notes: teleport_location_cache_for_* (teleport_location_cache_for_world, teleport_location_cache_for_freebuild, teleport_location_cache_for_world_the_end, teleport_location_cache_for_nether)
# permission: craftasy.denizen.world.teleportanker_platzieren
#
# Place two "teleportanker"-blocks. Right click one anchor while holding gold_ingot to teleport between them
#

# TODO: Skript verbessern und dann wieder aktivieren
# TODO: Zähler für Seelenmalus, geringer Einfluss weil Standard Item
# TODO: Admin Tool, alle Anker finden, Anker zerstören
# TODO: Rezept für Herstellung von Ankerblock, evtl. auch anderes Item
# TODO: Filter für Creativwelt etc.
# TODO: Flagging verbessern -> Script kompakter machen
# TODO: wiederholende Scriptteile wie Warnungen und Teleport in extra Task Scripts auslagern

# teleportanker.playerflag
# teleportanker.locationflag
# teleportanker.cuboidflag

#####################################################
# Debug
#####################################################

teleportanker_debug:
    type: task
    debug: true
    script:
        - define playeruuid <player.uuid>
        - foreach <server.online_players>:
            - flag <player> teleportanker_3_warnung:!
            - flag <player> teleportanker_1_platziert_<[playeruuid]>:!
            - flag <player> teleportanker_2_platziert_<[playeruuid]>:!
            - flag <player> teleportanker_1_location_<[playeruuid]>:!
            - flag <player> teleportanker_2_location_<[playeruuid]>:!
            - flag server teleportanker_uuid:!
            - flag <player> player_in_teleportanker_1_area:!
            - flag <player> player_in_teleportanker_close_1_area:!
            - flag <player> player_in_teleportanker_2_area:!
            - flag <player> player_in_teleportanker_close_2_area:!
            - note remove as:teleportanker_1_cuboid_<[playeruuid]>
            - note remove as:teleportanker_2_cuboid_<[playeruuid]>
            - note remove as:teleportanker_nah_1_cuboid_<[playeruuid]>
            - note remove as:teleportanker_nah_2_cuboid_<[playeruuid]>

#####################################################
# Teleport Item
#####################################################

teleportanker:
  type: item
  material: chiseled_polished_blackstone
  display name: <&3><&l>Teleportanker
  lore:
    - <empty>
    - <&3>Platziert diesen Teleportanker
    - <&3>und einen zweiten, um sie zu
    - <&3>verbinden. Macht einen Rechts-
    - <&3>klick während Ihr Seelenstaub
    - <&3>in der Hand haltet, um zwischen
    - <&3>den Ankern zu teleportieren.
    - <empty>
    - <&f><&m>---------------------------
    - <&7>Ab Rang: <&a>Vagabund
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&2><&chr[2714]>
    - <&f><&m>---------------------------
    - <&7>GEWÖHNLICH <&6>★<&7>☆☆☆☆

#####################################################
# World - Place anchor
#####################################################

teleportanker_placement:
    type: world
    debug: true
    enabled: false
    events:
        on player places teleportanker:
            # Permission test
            - if !<player.has_permission[craftasy.denizen.world.teleportanker_platzieren]>:
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - playeffect effect:block_crack at:<context.location> visibility:500 special_data:blackstone quantity:5
                - ratelimit <player> 10s
                - narrate format:c_info "Erweist Euch zunächst als würdig."
            - else:
                - define playeruuid <player.uuid>
                # Test if both Anchors already placed
                - if <player.has_flag[teleportanker.playerflag.anker1.placed]> && <player.has_flag[teleportanker.playerflag.anker2.placed]>:
                    - if !<player.has_flag[teleportanker.playerflag.anker3.warnung]>:
                        - determine passively cancelled
                        - flag <player> teleportanker.playerflag.anker3.warnung] expire:5m
                        - playeffect effect:block_crack at:<context.location> visibility:500 special_data:blackstone quantity:5
                        - playsound <player> sound:item_shield_block pitch:1
                        - narrate format:c_warn "Ihr habt bereits zwei Anker platziert. Einen dritten zu platzieren, ist keine gute Idee."
                    - else:
                        - determine passively cancelled
                        - take iteminhand
                        - playeffect effect:EXPLOSION_HUGE at:<context.location> visibility:500 quantity:12 offset:2.0
                        - playsound <player> sound:entity_dragon_fireball_explode pitch:0.2
                        - playsound <player> sound:PARTICLE_SOUL_ESCAPE pitch:0.1 volume:0.6
                        - random:
                            - adjust <player> velocity:-2,2,0
                            - adjust <player> velocity:0,2,1
                            - adjust <player> velocity:-1,3,-1
                        - hurt 7
                - else:
                    # Test if first anchor was placed
                    - if !<player.has_flag[teleportanker.playerflag.anker1.placed]>:
                        - if !<player.has_flag[teleportanker_2_location_<[playeruuid]>]>:
                            - narrate format:c_info "Ihr habt einen Teleportanker platziert. Wenn Ihr einen zweiten platziert, könnt Ihr zwischen ihnen teleportieren."
                            - take iteminhand
                            - playsound <player> sound:block_respawn_anchor_charge pitch:0.1
                            - playeffect effect:END_PORTAL_FRAME_FILL at:<context.location> visibility:500 quantity:5 offset:1.0
                            # flag the location with it's coordinates
                            - flag <context.location> teleportanker.locationflag.anker1.location.<[playeruuid]>:<context.location>
                            # flag the players uuid at the block location
                            - flag <context.location> teleportanker.locationflag.uuid:<[playeruuid]>
                            # flag the player for having placed the first anchor
                            - flag <player> teleportanker.playerflag.anker1.placed
                            # note an area around the first anchors location
                            - note <context.location.add[-25,-10,-25].to_cuboid[<context.location.add[25,10,25]>]> as:teleportanker_1_cuboid_<[playeruuid]>
                            - note <context.location.add[-5,-5,-5].to_cuboid[<context.location.add[5,5,5]>]> as:teleportanker_nah_1_cuboid_<[playeruuid]>
                        - else:
                            # flag the location with it's coordinates
                            - flag <context.location> teleportanker.locationflag.anker1.location.<[playeruuid]>:<context.location>
                            # flag the players uuid at the block location
                            - flag <context.location> teleportanker.locationflag.uuid:<[playeruuid]>
                            # flag the player for having placed the first anchor
                            - flag <player> teleportanker.playerflag.anker1.placed
                            # note an area around the first anchors location
                            - note <context.location.add[-5,-5,-5].to_cuboid[<context.location.add[5,5,5]>]> as:teleportanker_nah_1_cuboid_<[playeruuid]>
                            - take iteminhand
                            - playsound <player> sound:block_respawn_anchor_charge pitch:0.1
                            - playeffect effect:END_PORTAL_FRAME_FILL at:<context.location> visibility:500 quantity:5 offset:1.0
                            - wait 1.5s
                            - narrate format:c_info "Die Teleportanker wurden verbunden."
                            - playsound <player> sound:entity_wither_spawn volume:0.3 pitch:0.2
                            - playeffect effect:SOUL at:<context.location.points_around_y[radius=2;points=150]> visibility:500 quantity:1
                            - wait 2t
                            - playsound <player> sound:particle_soul_escape volume:2 pitch:1
                    - else:
                        # Test if second anchor was already placed
                        - if !<player.has_flag[teleportanker.playerflag.anker2.placed]>:
                            # flag the location with it's coordinates
                            - flag <context.location> teleportanker.locationflag.anker2.location.<[playeruuid]>:<context.location>
                            # flag the players uuid at the block location
                            - flag <context.location> teleportanker.locationflag.uuid:<[playeruuid]>
                            # flag the player for having placed the second anchor
                            - flag <player> teleportanker.playerflag.anker2.placed
                            # note an area around the second anchors location
                            - note <context.location.add[-5,-5,-5].to_cuboid[<context.location.add[5,5,5]>]> as:teleportanker_nah_2_cuboid_<[playeruuid]>
                            - take iteminhand
                            - playsound <player> sound:block_respawn_anchor_charge pitch:0.1
                            - playeffect effect:END_PORTAL_FRAME_FILL at:<context.location> visibility:500 quantity:5 offset:1.0
                            - wait 1.5s
                            - narrate format:c_info "Die Teleportanker wurden verbunden."
                            - playsound <player> sound:entity_wither_spawn volume:0.3 pitch:0.2
                            - playeffect effect:SOUL at:<context.location.points_around_y[radius=2;points=150]> visibility:500 quantity:1
                            - wait 1t
                            - playsound <player> sound:particle_soul_escape volume:2 pitch:1

#####################################################
# World - use Anchor
#####################################################

teleportanker_use:
    type: world
    debug: true
    enabled: false
    events:
        on player right clicks chiseled_polished_blackstone with:gold_ingot location_flagged:teleportanker_uuid:
            - define playeruuid <player.uuid>
            # world names of the anchor blocks location
            - define player_target_world_1 <context.location.flag[teleportanker.locationflag.anker1.location.<[playeruuid]>].world.name>
            - define player_target_world_2 <context.location.flag[teleportanker.locationflag.anker2.location.<[playeruuid]>].world.name>
            # test if block location matches value in player flag for location 1
            - if <context.location> == <player.flag[teleportanker_1_location_<[playeruuid]>]>:
                # if player has no second anchor placed, stop
                - if !<player.has_flag[teleportanker_2_location_<[playeruuid]>]>:
                    - playsound <player> sound:item_shield_block pitch:1
                    - ratelimit <player> 10s
                    - narrate format:c_warn "Ihr habt keinen zweiten Anker verbunden."
                    - stop
                - else:
                    - ratelimit <player> 1t
                    - if <context.location.world.name> == <[player_target_world_2]>:
                        # teleport player to second anchor location, without stopover
                        - take iteminhand
                        - teleport <player> <player.flag[teleportanker_2_location_<[playeruuid]>].add[2,0,0]>
                        - run teleportanker_use_arrival_task
                    - else:
                        # teleport player to second anchor location, with stopover in target world cache/waiting location
                        - take iteminhand
                        - teleport <player> teleport_location_cache_for_<[player_target_world_2]>
                        - wait 4s
                        - playsound <player> sound:block_bell_resonate pitch:0.2
                        - wait 4s
                        - teleport <player> <player.flag[teleportanker_2_location_<[playeruuid]>].add[2,0,0]>
                        - run teleportanker_use_arrival_task
            # test if block location matches value in player flag for location 2
            - if <context.location> == <player.flag[teleportanker_2_location_<[playeruuid]>]>:
                # if player has no second anchor placed, stop
                - if !<player.has_flag[teleportanker_1_location_<[playeruuid]>]>:
                    - playsound <player> sound:item_shield_block pitch:1
                    - ratelimit <player> 10s
                    - narrate format:c_warn "Ihr habt keinen zweiten Anker verbunden."
                    - stop
                - else:
                    - ratelimit <player> 1t
                    - if <context.location.world.name> == <[player_target_world_1]>:
                        # teleport player to first anchor location, without stopover
                        - take iteminhand
                        - teleport <player> <player.flag[teleportanker_1_location_<[playeruuid]>].add[2,0,0]>
                        - run teleportanker_use_arrival_task
                    - else:
                        # teleport player to first anchor location, with stopover in target world cache/waiting location
                        - take iteminhand
                        - teleport <player> teleport_location_cache_for_<[player_target_world_1]>
                        - wait 4s
                        - playsound <player> sound:block_bell_resonate pitch:0.2
                        - wait 4s
                        - teleport <player> <player.flag[teleportanker_1_location_<[playeruuid]>].add[2,0,0]>
                        - run teleportanker_use_arrival_task def:<player>

teleportanker_use_arrival_task:
    type: task
    debug: true
    definitions: player
    script:
        - cast blindness duration:2.5s hide_particles no_icon
        - playsound <[player]> sound:entity_illusioner_mirror_move pitch:1
        - playeffect effect:soul_fire_flame at:<[player].location> visibility:500 quantity:120 offset:1.5
        - playeffect effect:soul at:<[player].location> visibility:500 quantity:120 offset:1.5
        - wait 0.2
        - playsound <[player]> sound:entity_illusioner_prepare_blindness pitch:1

#####################################################
# World - break Anchor
#####################################################

teleportanker_break:
    type: world
    debug: true
    enabled: false
    events:
        on player breaks chiseled_polished_blackstone location_flagged:teleportanker_uuid:
            - define playeruuid <player.uuid>
            # test if location flag uuid is the same as playeruuid, cancel if not
            - if !( <context.location.flag[teleportanker_uuid]> == <[playeruuid]> ):
                - determine passively cancelled
                - playsound <player> sound:item_shield_block pitch:1
                - narrate format:c_warn "Dieser Teleportanker gehört Euch nicht!"
            - else:
                - if <player.has_flag[teleportanker_1_location_<[playeruuid]>]>:
                    - if <context.location> == <player.flag[teleportanker_1_location_<[playeruuid]>]>:
                        - determine passively NOTHING
                        - drop teleportanker <context.location>
                        - playsound <player> sound:block_respawn_anchor_deplete pitch:0.2
                        - flag <player> teleportanker_1_location_<[playeruuid]>:!
                        - flag <context.location> teleportanker_uuid:!
                        - flag <player> player_in_teleportanker_1_area:!
                        - flag <player> player_in_teleportanker_close_1_area:!
                        - note remove as:teleportanker_1_cuboid_<[playeruuid]>
                        - note remove as:teleportanker_nah_1_cuboid_<[playeruuid]>
                - if <player.has_flag[teleportanker_2_location_<[playeruuid]>]>:
                    - if <context.location> == <player.flag[teleportanker_2_location_<[playeruuid]>]>:
                        - determine passively NOTHING
                        - drop teleportanker <context.location>
                        - playsound <player> sound:block_respawn_anchor_deplete pitch:0.2
                        - flag <player> teleportanker_2_location_<[playeruuid]>:!
                        - flag <context.location> teleportanker_uuid:!
                        - flag <player> player_in_teleportanker_2_area:!
                        - flag <player> player_in_teleportanker_close_2_area:!
                        - note remove as:teleportanker_2_cuboid_<[playeruuid]>
                        - note remove as:teleportanker_nah_2_cuboid_<[playeruuid]>

#####################################################
# Command - get Anchor coordinates
#####################################################

teleportanker_coordinates:
    type: command
    debug: true
    name: anker
    description: Wo sind meine Teleportanker?
    usage: /anker
    aliases:
    - ankerwo
    - anchor
    - anchorcords
    script:
        - if !<player.has_permission[craftasy.denizen.world.teleportanker_platzieren]>:
            - playsound <player> sound:item_shield_block pitch:1
            - ratelimit <player> 10s
            - narrate format:c_info "Diesen Befehl könnt Ihr derzeit nicht nutzen."
            - stop
        - else:
            - define playeruuid <player.uuid>
            - define ankercords1 <player.flag[teleportanker_1_location_<[playeruuid]>].xyz>
            - define ankercords2 <player.flag[teleportanker_2_location_<[playeruuid]>].xyz>
            - define ankerworld1 <player.flag[teleportanker_1_location_<[playeruuid]>].world.name>
            - define ankerworld2 <player.flag[teleportanker_2_location_<[playeruuid]>].world.name>
            - if !( <player.has_flag[teleportanker_1_location_<[playeruuid]>]> || <player.has_flag[teleportanker_2_location_<[playeruuid]>]> ):
                - playsound <player> sound:item_shield_block pitch:1
                - ratelimit <player> 10s
                - narrate format:c_warn "Ihr habt keinen Teleportanker platziert!"
                - stop
            - else:
                - define ankertest1 "<tern[<player.has_flag[teleportanker_1_location_<[playeruuid]>]>].pass[<&a><[ankercords1]> <[ankerworld1]>].fail[<&c>kein Anker]>"
                - define ankertest2 "<tern[<player.has_flag[teleportanker_2_location_<[playeruuid]>]>].pass[<&a><[ankercords2]> <[ankerworld2]>].fail[<&c>kein Anker]>"
                - narrate format:headerOhneText "<empty>"
                - narrate <empty>
                - narrate "<&3>➤ <&b>Anker 1 <[ankertest1]> <&b>| Anker 2 <[ankertest2]>"
                - narrate <empty>
                - narrate format:footerOhneText "<empty>"

#####################################################
# World - particle effects
#####################################################

teleportanker_area:
    type: world
    debug: true
    enabled: false
    events:
        # particle effects every second aorund anchor for players in wider area around it
        on player enters teleportanker_1_cuboid_*:
            - flag <player> player_in_teleportanker_1_area
            - while <player.has_flag[player_in_teleportanker_1_area]>:
                - random:
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=2;points=20]> visibility:500 quantity:1 targets:<player>
                        - wait 1s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=2;points=5]> visibility:500 quantity:1 targets:<player>
                        - wait 2s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=10]> visibility:500 quantity:1 targets:<player>
                        - wait 0.5s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=5]> visibility:500 quantity:1 targets:<player>
                        - wait 2.5s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=3]> visibility:500 quantity:1 targets:<player>
                        - wait 2.5s
                        - playeffect effect:soul at:<context.area.center.points_around_y[radius=1;points=3]> visibility:500 quantity:1 targets:<player>
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=8]> visibility:500 quantity:1 targets:<player>
                        - wait 1.5s
                        - playeffect effect:soul at:<context.area.center> visibility:500 quantity:1 offset:1 targets:<player>
        on player exits teleportanker_1_cuboid_*:
            - flag <player> player_in_teleportanker_1_area:!
        on player enters teleportanker_2_cuboid_*:
            - flag <player> player_in_teleportanker_2_area
            - while <player.has_flag[player_in_teleportanker_2_area]>:
                - random:
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=2;points=20]> visibility:500 quantity:1 targets:<player>
                        - wait 1s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=2;points=5]> visibility:500 quantity:1 targets:<player>
                        - wait 2s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=10]> visibility:500 quantity:1 targets:<player>
                        - wait 0.5s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=5]> visibility:500 quantity:1 targets:<player>
                        - wait 2.5s
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=3]> visibility:500 quantity:1 targets:<player>
                        - wait 2.5s
                        - playeffect effect:soul at:<context.area.center.points_around_y[radius=1;points=3]> visibility:500 quantity:1 targets:<player>
                    - repeat 1:
                        - playeffect effect:soul_fire_flame at:<context.area.center.points_around_y[radius=1;points=8]> visibility:500 quantity:1 targets:<player>
                        - wait 1.5s
                        - playeffect effect:soul at:<context.area.center> visibility:500 quantity:1 offset:1 targets:<player>
        on player exits teleportanker_2_cuboid_*:
            - flag <player> player_in_teleportanker_2_area:!
        # sound effects every second aorund anchor for players in close area around it
        on player enters teleportanker_nah_1_*:
            - flag <player> player_in_teleportanker_close_1_area
            - while <player.has_flag[player_in_teleportanker_close_1_area]>:
                - playsound <player> sound:BLOCK_CONDUIT_AMBIENT pitch:1
                - wait 1s
        on player exits teleportanker_nah_1_*:
            - flag <player> player_in_teleportanker_close_1_area:!
        on player enters teleportanker_nah_2_*:
            - flag <player> player_in_teleportanker_close_2_area
            - while <player.has_flag[player_in_teleportanker_close_2_area]>:
                - playsound <player> sound:BLOCK_CONDUIT_AMBIENT pitch:1
                - wait 1s
        on player exits teleportanker_nah_2_*:
            - flag <player> player_in_teleportanker_close_2_area:!