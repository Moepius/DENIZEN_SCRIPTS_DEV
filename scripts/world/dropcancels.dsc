# schaltet Mobdrops in Freebuild und Projektwelt ab

dropcancels:
    type: world
    debug: false
    events:
        on mob dies in:orbis:
            - determine NO_DROPS
        on mob dies in:world:
            - determine NO_DROPS