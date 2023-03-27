world_handler:
    type: world
    debug: true
    enabled: true
    # data:
    events:
        on server prestart:
            - foreach <server.worlds> as:world:
                - createworld <[world].name>
                - adjust <[world]> keep_spawn:true
                - announce to_console "Welt -<[world].name>- wurde geladen!"