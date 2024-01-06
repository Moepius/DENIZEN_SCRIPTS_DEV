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

# combo test
combo_events:
    type: world
    debug: false
    events:
        on player right clicks block with:todesschaufel:
            - determine cancelled passively
            - narrate "Rechtsklick!"

todesschaufel:
    type: item
    material: wooden_shovel
    display name: <&f><&l>Todesschaufel
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&7>Testitem für Skill-Combos.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&c>Admintool


## CONFIG STARTS ##
hud_config:
    type: data

    # Update period in ticks. Must be a factor of 20 (recommended to be either 5 or 10)
    update_delay: 5

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
                - actionbar <script[hud_events].data_key[hud_text].parsed> targets:<[playerList]> per_player
                - wait <script[hud_config].data_key[update_delay]>t

    # Generates the HUD text
    # TODO: Register combos
    combo_success: <&2>[<&a>------<&2>]
    combo_fail: <&4>[<&c>xxxxx<&4>]
    hud_text: "<player.flag[player.hud.hotbar_row.row_changed].if_null[<&7>▲▼]> <&a>[RLRLRL]              <&2>⌛ <player.location.world.time.proc[hud_format_time]> <&b>🔥 100 <&5>✺ 100"

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
