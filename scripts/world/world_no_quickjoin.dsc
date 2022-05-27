world_no_quickjoin:
    type: world
    debug: false
    events:
        on server prestart:
        - flag server startup_inprog duration:10s
        on player logs in server_flagged:startup_inprog:
        - determine "Der Server lädt noch!"
        on server list ping server_flagged:startup_inprog:
        - determine passively "<&c>Server lädt..."
        - determine passively VERSION_NAME:Loading
        - determine passively PROTOCOL_VERSION:999