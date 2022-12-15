
core_login_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player joins:
        - determine none passively
        after player joins:
        # initial flagging on join
        # flag last login timestamp
        - flag <player> player.core.lastlogin.timestamp:<time[<util.time_now>]>

        # player joining announcment
        - foreach <server.online_players>:
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:1.5
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:1.5
            - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>betritt den Server."
            - wait 3s
            - run task_motd def:<player>
        on player quits:
        - determine none passively
        after player quits:
        # initial flagging on quitting
        # flag last quit timestamp
        - flag <player> player.core.lastquit.timestamp:<time[<util.time_now>]>
        # player quitting announcment
        - foreach <server.online_players>:
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:0.2
            - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:0.2
            - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>hat den Server verlassen."