# protection of worlds against most obvious griefing methods and exploits
# protection against using portals etc.

# TODO: Mob Spawn Protection hinzufügen (Wither, Enderdrache, etc.)
# TODO: place all prevention scripts into this script

portal_disable:
    type: world
    debug: false
    events:
        on portal created because FIRE|NETHER_PAIR|END_PLATFORM:
            - determine passively cancelled