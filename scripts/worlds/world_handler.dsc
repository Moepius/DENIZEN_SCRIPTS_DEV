world_handler:
    type: world
    debug: true
    enabled: true
    # data:
    events:
        on server prestart:
            - define worlds_overworld <list[world|avarus|orbis|arboretum|baumschule|silberlab|world_lager|dungeon]>
            - foreach <[worlds_overworld]> as:world:
                - createworld <[world]>
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world].name> wurde geladen!"
            - define worlds_nether <list[orcus|world_nether]>
            - foreach <[worlds_nether]> as:world:
                - createworld <[world]> environment:NETHER
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world].name> wurde geladen!"
            - define worlds_the_end <list[kaos|world_the_end|hortusmanium]>
            - foreach <[worlds_the_end]> as:world:
                - createworld <[world]> environment:THE_END
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world].name> wurde geladen!"

# flag server server.worlds.enabled_worlds:world|avarus|hortusmanium|orbis|creative|baumschule|avarus_nether|avarus_the_end|world_nether|world_the_end|avarus_abbau|schematic