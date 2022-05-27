command_hilfe:
    type: command
    debug: false
    name: hilfe
    description: Craftasy Hilfemenü
    usage: /hilfe
    aliases:
    - help
    - guide
    - hilf
    - tutorial
    script:
    - playsound <player> sound:ui_toast_in volume:1 pitch:1
    - wait 0.5s
    - execute as_op "interface Hilfe"