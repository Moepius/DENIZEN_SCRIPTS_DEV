command_lastlogout:
  type: command
  debug: false
  name: lastlogout
  description: Zuletztgesehen
  permission: d.seen
  usage: /lastlogout
  aliases:
  - lastseen
  - seen
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>Bitte gebt einen Spieler an."
    - else:
      - define spieler <context.args.get[1]>
      - narrate <[spieler]>
      - define sp_uuid <player[<[spieler]>].uuid>
      - narrate <[sp_uuid]>
    - if <[sp_uuid].is_player>:
        - if <[sp_uuid].is_online>:
          - narrate format:c_info "<[sp_uuid].name> ist online."
        - else:
          - define log_year <[sp_uuid].last_played_time.year>
          - define log_month <[sp_uuid].last_played_time.month>
          - define log_day <[sp_uuid].last_played_time.day>
          - define log_hour <[sp_uuid].last_played_time.hour>
          - define log_minute <[sp_uuid].last_played_time.minute>
          - narrate format:c_info "<&e><[sp_uuid].name><&r> loggte sich am <&e><[log_day]>.<[log_month]>.<[log_year]><&r> um <&e><[log_hour]><&co><[log_minute]> Uhr<&r> aus."
    - else:
        - narrate format:c_info "<&e><context.args.get[1]><&r> ist kein bekannter Spieler!"