
# TODO: let the player set backlocations (current location + name) up to 10 locations

command_back:
    type: command
    debug: false
    name: back
    description: teleport to your last location
    usage: /back
    aliases:
    - ba
    tab completions:
        1: <list[<player.flag[player.commands.teleport.backlocations]>]>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.back]>:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[error.no_permission].parse_color>
            - stop
        - if <context.args.size> > 1:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[error.too_many_args].parse_color>
            - stop
        - if !<player.has_flag[player.commands.teleport.backlocations]> || !<player.has_flag[player.commands.teleport.lastlocation]>:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[command_back.no_backlocations].parse_color>
            - stop
        - define backlocation <player.flag[player.commands.teleport.backlocations]>
        - define lastlocation <player.flag[player.commands.teleport.lastlocation]>
        - if <context.args.is_empty>:
            - teleport <player> <player.flag[player.commands.teleport.lastlocation]>
        - if !<player.flag[player.commands.teleport.backlocations].contains[<context.args.get[1]>]>:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[command_back.location_not_valid].parse_color>
            - stop
        # get the name of the saved backlocation of the player flag and match it with the saved backlocations with the actual location info
        # some flag like server.core.playerlocations.backlocation.<player.uuid>.<[locationname]>:<player.location>

# https://paste.denizenscript.com/View/100571 notiz
# thread: https://discord.com/channels/315163488085475337/1011711170048163890/1011711411283566643