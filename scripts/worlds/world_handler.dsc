world_handler:
    type: world
    debug: true
    enabled: true
    # data:
    events:
        on server prestart:
            - define worldlist <list[world|avarus|hortusmanium|orbis|creative|baumschule|schematic|avarus_nether|avarus_the_end|world_nether|world_the_end|avarus_abbau|parallelwelt]>
            - foreach <[worldlist]> as:world:
                - createworld <[world]>
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world].name> wurde geladen!"

# flag server server.worlds.enabled_worlds:world|avarus|hortusmanium|orbis|creative|baumschule|avarus_nether|avarus_the_end|world_nether|world_the_end|avarus_abbau