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
    debug: true
    events:
        on player right clicks *_trapdoor|*_door flagged:!player.debug.trappdor_protection in:protected_*:
            - if !<player.has_flag[player.core.protection.door_cooldown]>:
                - flag <player> player.core.protection.door_cooldown expire:2.3s
                - narrate "block geklickt!"
                - define clicked_block:<context.location.material>
                - wait 2s
                - modifyblock <context.location> <[clicked_block]>
            - else:
                - narrate "cooldown"
                - determine passively cancelled