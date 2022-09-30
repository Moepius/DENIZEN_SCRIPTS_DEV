## =====================================##
## Displays a Coordinates and Time HUD  ##
## by @seb303                           ##
## v1.0.1 2022-06-08                    ##
## Tested with Denizen-1.2.4-b6247-DEV  ##  https://ci.citizensnpcs.co/job/Denizen_Developmental/
## =====================================##

## -------- ##
## COMMANDS ##
## -------- ##
#
# To show the HUD:
# /hud on
# /coords on
#
# To hide the HUD:
# /hud off
# /coords off
#
# Permission needed: custom.hud


## CONFIG STARTS ##
hud_config:
    type: data

    # Update period in ticks. Must be a factor of 20 (recommended to be either 5 or 10)
    update_delay: 10

## CONFIG ENDS ##



# ----------------------------------------------------------------------------------------
# Player flags:
# hud.on    - HUD is shown for this player (set/cleared by the commands in this script)
# hud.dark  - player is in a bright biome (then hud will use dark text)
# hud.off   - HUD is disabled for this player, takes priority over hud.on
#             (can be set by another Denizen script which needs to use the actionbar space)
# ----------------------------------------------------------------------------------------

hud_events:
    type: world
    debug: false
    events:

        # Secondly event to show coordinates & time
        on delta time secondly:
            - repeat <element[20].div[<script[hud_config].data_key[update_delay]>].round_down>:
                - define playerList <server.online_players_flagged[hud.on].filter[has_flag[hud.off].not]>
                - actionbar <script[hud_events].data_key[hud_text].parsed> targets:<[playerList].filter[has_flag[hud.dark]]> per_player
                - wait <script[hud_config].data_key[update_delay]>t

    # Generates the HUD text
    hud_text: "<&3>1/4 <&a>[RLRLRL]  <&2>⌛ <player.location.world.time.proc[hud_format_time]> <&b>🔥 0/10 <&5>✺ 0/10"

hud_format_time:
    type: procedure
    debug: false
    definitions: world_time
    script:
        - define hours <[world_time].div[1000].round_down>
        - if <[hours]> < 18:
            - define hours:+:6
        - else:
            - define hours:-:18
        - define minutes <[world_time].mod[1000].div[16.6666667].round_down.pad_left[2].with[0]>
        - determine <[hours]>:<[minutes]>

hud_command:
    type: command
    debug: false
    name: hud
    aliases:
        - coords
    description: Command to display a Coordinates and Time HUD
    usage: /hud on|off
    tab completions:
        1: on|off
    permission: custom.hud

    show_docs:
        - narrate "<&[error]>/<context.alias> on|off"
        - stop

    script:
        - if <context.args.size> != 1:
            - inject hud_command.show_docs
        - choose <context.args.first>:
            - case on:
                - flag <player> hud.on
            - case off:
                - flag <player> hud.on:!
            - default:
                - inject hud_command.show_docs
