# +----------------------
# |
# | T o r c h   L i g h t
# |
# | Light from your torch without placing it!
# |
# +----------------------
#
# @author mcmonkey
# @forked by Moepius
# @date 2022/05/02
# @script-version 4.0
# @Denizen version Denizen-1.2.4-b1767-REL
#
# Installation:
# Just put the script in your scripts folder and reload.
#
# Configuration
# You can add extra items and/or change their levels at the marked section below.
#
# Usage:
# Hold a torch and run around! Also works in your offhand!
#
# Important:
# GLitched blocks hanging in the air ("levitating" grass, fern halfs, etc.) will break when walking next to them.
# When running through 2 blocks tall grass, fern, etc. the light won't show.
# Doesn't work under water.
#
# ---------------------------- END HEADER ----------------------------


torch_light_config:
    type: data
    items:
    # =============== Add more material names here ===============
    - torch
    - lantern
    - redstone_torch
    - glowstone
    - glowstone_dust
    - soul_lantern
    - redstone_lamp
    - sea_lantern
    - end_rod
    levels:
      # =============== Add alternate levels here ===============
      redstone_torch: 10
      glowstone_dust: 6
      soul_lantern: 6
    # =============== end of editable section ===============

torch_light_world:
    type: world
    debug: false
    subpaths:
        reset_delayed:
        - if !( <[1].material.name> == light ):
            - stop
        - else:
            - modifyblock <[1]> air no_physics
        reset:
        - if <player.has_flag[torch_light_loc]>:
            - if <player.flag[torch_light_loc].simple> == <[loc].simple||null>:
                - stop
            - run torch_light_world.subpaths.reset_delayed def:<player.flag[torch_light_loc]> delay:2t
            - flag <player> torch_light_loc:!
        update:
        - define loc <player.location.add[0,1,0]>
        - if !( <[loc].material.name> == air ):
            - stop
        - else:
            - if <script[torch_light_config].data_key[items].contains[<player.item_in_hand.material.name||null>]>:
                - inject torch_light_world.subpaths.reset
                - modifyblock <[loc]> light[level=<script[torch_light_config].data_key[levels.<player.item_in_hand.material.name>]||14>] no_physics
                - flag <player> torch_light_loc:<[loc]>
            - else if <script[torch_light_config].data_key[items].contains[<player.item_in_offhand.material.name||null>]>:
                - inject torch_light_world.subpaths.reset
                - modifyblock <[loc]> light[level=<script[torch_light_config].data_key[levels.<player.item_in_offhand.material.name>]||14>] no_physics
                - flag <player> torch_light_loc:<[loc]>
            - else:
                - define loc:!
                - inject torch_light_world.subpaths.reset
    events:
        after player drops item:
        - inject torch_light_world.subpaths.update
        after player holds item:
        - inject torch_light_world.subpaths.update
        after player steps on block:
        - inject torch_light_world.subpaths.update
        on player quits:
        - inject torch_light_world.subpaths.reset
