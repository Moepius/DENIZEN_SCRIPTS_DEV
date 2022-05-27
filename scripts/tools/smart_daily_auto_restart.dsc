auto_restarter_world:
    type: world
    debug: false
    events:
        on system time 03:00:
        - run auto_restarter_task
        on player logs in server_flagged:restart_happening:
        - determine "Gekickt: Der Server wird aktuell neu gestartet!"

auto_restarter_task:
    type: task
    debug: false
    script:
    - wait 1m
    - define marks <list[30m|20m|15m|10m|5m|4m|3m|2m|1m|30s|15s|10s|5s].parse[as_duration]>
    - foreach <[marks]> as:mark:
        - if <server.online_players.is_empty>:
            - foreach stop
        - define display_in "<[mark].formatted.replace[s].with[ Sekunden].replace[m].with[ Minuten].replace[1 Minuten].with[1 Minute]>"
        - announce format:c_info "<&c>Server wird in <[display_in]> automatisch neu gestartet."
        - if <[mark].in_seconds> <= 60:
            - title "subtitle:<&c>Neustart in <[display_in]>." fade_out:10s targets:<server.online_players>
            - flag server restart_happening duration:<[mark].add[10s]>
        - wait <[mark].sub[<[marks].get[<[loop_index].add[1]>]||0s>]||5s>
    - flag server restart_happening duration:5s
    - announce format:c_warn "<&c>Server wird jetzt neu gestartet!"
    - kick <server.online_players> "reason: Server wird gerade neu gestartet. Bitte einen Moment Geduld!"
    - wait 1s
    - adjust server restart