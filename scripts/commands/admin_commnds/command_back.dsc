

command_back:
    type: command
    debug: false
    name: back
    description: teleport to your last location
    usage: /back
    aliases:
    - ba
    tab completions:
        1: <list[<player.flag[player.command.back.back_locations]>]>
    