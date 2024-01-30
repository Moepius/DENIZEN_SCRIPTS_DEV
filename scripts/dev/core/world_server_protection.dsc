# protection of worlds against most obvious griefing methods and exploits
# protection against using portals etc.

# TODO: Mob Spawn Protection hinzufügen (Wither, Enderdrache, etc.)
# TODO: place all prevention scripts into this script

######## IDEAS #########

# Protecting doors and trapdoors:
# players who interact with doors/trapdoors in protected areas will trigger fallging of a location if they are not in building mode
# flagged locations will reset the state after a few seconds ... so that trapdoors close automatically


portal_disable:
    type: world
    debug: false
    events:
        on portal created because FIRE|NETHER_PAIR|END_PLATFORM:
            - determine passively cancelled

trapdoor_protection:
    type: world
    debug: false
    events:
        on player right clicks *_trapdoor|*_door flagged:!player.debug.trappdor_protection in:protected_*|zeitkapsel:
            - if !<player.has_flag[player.core.protection.door_cooldown]>:
                # set cooldown flag
                - flag <player> player.core.protection.door_cooldown expire:2.3s
                # get clicked block
                - define clicked_block:<context.location.material>
                - wait 2s
                # test if door
                - if <context.location.material.name.advanced_matches[*_door]>:
                    # test for hinge (right or left)
                    - define face <context.location.block_facing>
                    - if <context.location.material.hinge> == left:
                    # Note: pi/2 is radian equivalent of 90 degrees.
                        - define face <[face].rotate_around_y[-<util.pi.div[2]>]>
                    - else:
                        - define face <[face].rotate_around_y[<util.pi.div[2]>]>
                    - define door2 <context.location.add[<[face]>]>
                    # Check that the double door *exists*
                    - if <[door2].material.name> == <context.location.material.name>:
                        - switch <[door2]>
                 # reset to clicked block
                - modifyblock <context.location> <[clicked_block]>
            - else:
                - determine passively cancelled