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

    # How the directions are displayed
    directions:
        north: N [-Z]
        northeast: NE
        east: E [+X]
        southeast: SE
        south: S [+Z]
        southwest: SW
        west: W [-X]
        northwest: NW

    # Bright biomes which will cause dark HUD colors to be used
    bright_biomes:
        - desert
        - desert_hills
        - ice_desert
        - beach
        - snowy_beach
        - cold_beach
        - snowy_tundra
        - cold_tundra
        - ice_flats
        - mutated_ice_flats
        - snowy_taiga
        - snowy_taiga_hills
        - snowy_taiga_mountains
        - cold_taiga
        - cold_taiga_hills
        - cold_taiga_mountains
        - ice_mountains
        - snowy_mountains
        - cold_mountains
        - extreme_hills
        - extreme_hills_plus_mountains
        - gravelly_mountains
        - modified_gravelly_mountains
        - ice_plains
        - ice_plains_spike
        - ice_spikes
        - frozen_river

    # See here for ways to specify colors: https://meta.denizenscript.com/Docs/Tags#base
    # HUD text color 1 for darker biomes
    light_color1: <gold>
    # HUD text color 2 for darker biomes
    light_color2: <white>
    # HUD text color 1 for bright biomes
    dark_color1: <dark_blue>
    # HUD text color 1 for bright biomes
    dark_color2: <dark_aqua>

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
        # 2 secondly event to check/update biome for each player
        on delta time secondly every:2:
            - define bright_biomes <script[hud_config].data_key[bright_biomes]>
            - foreach <server.online_players_flagged[hud.on]> as:__player:
                - if <player.location.chunk.is_loaded>:
                    - if <[bright_biomes].contains[<player.location.biome.name>]>:
                        - flag <player> hud.dark
                    - else:
                        - flag <player> hud.dark:!

        # Secondly event to show coordinates & time
        on delta time secondly:
            - repeat <element[20].div[<script[hud_config].data_key[update_delay]>].round_down>:

                - define playerList <server.online_players_flagged[hud.on].filter[has_flag[hud.off].not]>

                # Show hud in light mode (darker biomes)
                - define color1 <script[hud_config].data_key[light_color1].parsed>
                - define color2 <script[hud_config].data_key[light_color2].parsed>
                - actionbar <script[hud_events].data_key[hud_text].parsed> targets:<[playerList].filter[has_flag[hud.dark].not]> per_player

                # Show hud in dark mode (brighter biomes)
                - define color1 <script[hud_config].data_key[dark_color1].parsed>
                - define color2 <script[hud_config].data_key[dark_color2].parsed>
                - actionbar <script[hud_events].data_key[hud_text].parsed> targets:<[playerList].filter[has_flag[hud.dark]]> per_player

                - wait <script[hud_config].data_key[update_delay]>t

    # Generates the HUD text
    hud_text: "<[color1]>XYZ: <[color2]><player.location.round_down.xyz.replace_text[,].with[ ]>  <[color1]><script[hud_config].parsed_key[directions.<player.location.direction>].pad_right[8]> <[color2]><player.location.world.time.proc[hud_format_time]>"

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
