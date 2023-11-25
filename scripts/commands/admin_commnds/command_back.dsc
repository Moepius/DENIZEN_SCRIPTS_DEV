# Script made by Hannybee (Discord-Tag: hannybee)
## This Script creates a /back command alternative

# Used Permissions:
#   - craftasy.denizen.command.back               - allows access to the command /back.
#   - craftasy.denizen.command.backl              - allows access to the command /backl.

# Back command, der einen zu dem letzten speicherpunkt bringt
back_command:
    type: command
    debug: true
    name: back
    description: teleports back to the last saved location
    usage: /back
    permission: craftasy.denizen.command.back
    script:
    - if <context.source_type> != PLAYER:
        - stop
    - if !<player.has_flag[lastlocation]>:
        - run chatsounds_error
        - narrate format:c_warn "Es gibt keine gespeicherten Positionen!"
        - stop
    - teleport <player> <player.flag[lastlocation]>
    - stop

# Backl command, der einen zu dem letzten speicherpunkt einer bestimmten welt bringt
backl_command:
    type: command
    debug: true
    name: backl
    description: teleports to a saved location
    usage: /backl <&lt>world<&gt>
    permission: craftasy.denizen.command.backl
    tab completions:
        1: <player.flag[world].keys.if_null[]>
    script:
    - if <context.source_type> != PLAYER:
        - stop
    - if <context.args.size> < 1:
        - narrate "<red>Bitte gebe eine Welt an."
        - stop
    - if !<player.has_flag[world.<context.args.first>.lastlocation]>:
        - narrate "<red>Du hast keine gespeicherte Postition für diese Welt."
        - stop
    - teleport <player> <player.flag[world.<context.args.first>.lastlocation]>
    - stop

world_change:
    type: world
    debug: false
    enabled: true
    events:
        # Minütliches speichern des letzten ortes in einer welt
        on system time minutely:
        - if <server.online_players.size> == 0:
            - stop
        - foreach <server.online_players>:
            # speichert per welt
            - flag <[value]> world.<[value].location.world.name>.lastlocation:<[value].location>
            # speichert die zuletzt gespeicherte position
            - flag <[value]> lastlocation:<[value].location>
            - stop

        # Speichern beim ersten betreten einer welt
        after player changes world:
        - flag <player> world.<context.destination_world.name>.lastlocation:<player.location>
        - stop

        # Speichern beim einloggen
        after player join:
        - flag <player> world.<player.location.world.name>.lastlocation:<player.location>
        - stop

        # Speichern beim ausloggen
        after player quit:
        - flag <player> world.<player.location.world.name>.lastlocation:<player.location>
        - stop