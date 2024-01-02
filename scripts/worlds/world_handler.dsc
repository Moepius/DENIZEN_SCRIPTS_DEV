world_handler:
    type: world
    debug: false
    enabled: true
    # data:
    events:
        on server prestart:
            - define worlds_overworld <list[world|avarus|orbis|arboretum|baumschule|silberlab|world_lager|dungeon|orbis_west]>
            - foreach <[worlds_overworld]> as:world:
                - createworld <[world]>
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world]> wurde geladen!"
            - define worlds_nether <list[orcus|world_nether]>
            - foreach <[worlds_nether]> as:world:
                - createworld <[world]> environment:NETHER
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world]> wurde geladen!"
            - define worlds_the_end <list[kaos|world_the_end|hortusmanium]>
            - foreach <[worlds_the_end]> as:world:
                - createworld <[world]> environment:THE_END
                - adjust <world[<[world]>]> keep_spawn:true
                - announce to_console "Welt <[world]> wurde geladen!"

# flag server server.worlds.enabled_worlds:world|avarus|orbis|arboretum|baumschule|silberlab|world_lager|dungeon|orcus|world_nether|kaos|world_the_end|hortusmanium|orbis_west
# todo: data script benutzen für eingeschaltetet welten und in config platzieren