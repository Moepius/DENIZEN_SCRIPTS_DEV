command_regeln:
    type: command
    debug: false
    name: regeln
    description: Craftasy Regelwerk
    usage: /regeln
    aliases:
    - rules
    - rule
    - regel
    - gesetz
    script:
    - playsound <player> sound:ui_toast_in volume:1 pitch:1
    - wait 0.5s
    - execute as_op "interface Regeln"