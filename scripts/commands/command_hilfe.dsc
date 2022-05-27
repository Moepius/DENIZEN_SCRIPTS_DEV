# TODO: Hilfemenü einblenden

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
    - wait 0.2s
    - narrate format:c_info "Noch keine Hilfe verfügbar"