
#######################################
# scrollabe inventory
#######################################

# change hotbar row with sneak + scroll

scrollable_inventory_events:
    type: world
    debug: false

    # flags
    row_changed: player.hud.hotbar_row.row_changed
    hotbar: player.hud.hotbar_row.current_hotbar
    row_one: player.hud.hotbar_row.row_one
    row_two: player.hud.hotbar_row.row_two
    row_three: player.hud.hotbar_row.row_three
    next_row: player.hud.hotbar_row.next_row
    scroll_type: player.hud.hotbar_row.scroll_type
    new_inventory: player.hud.hotbar_row.new_inventory
    # permissions
    use_inventory_scrolling: craftasy.denizen.hud.inventory_scroll

    # events
    events:
        on player scrolls their hotbar:
        # tests
        - if !<player.is_sneaking>:
            - stop
        - if !<player.has_permission[craftasy.denizen.hud.inventory_scroll]>:
            - stop
        - determine cancelled passively
        # "down" scroll, from last to first slot
        - if <context.new_slot> == 1 && <context.previous_slot> == 9:
            - run scrollable_inventory_task def:<player>|<&7>▲<&a>▼|down
            - inject <script> path:swap_hotbar
        # "up" scroll, , from first to last slot
        - if <context.new_slot> == 9 && <context.previous_slot> == 1:
            - run scrollable_inventory_task def:<player>|<&a>▲<&7>▼|up
            - inject <script> path:swap_hotbar
        # "down" scroll
        - if <context.new_slot> > <context.previous_slot>:
            - run scrollable_inventory_task def:<player>|<&7>▲<&a>▼|down
            - inject <script> path:swap_hotbar
        # "up" scroll
        - if <context.new_slot> < <context.previous_slot>:
            - run scrollable_inventory_task def:<player>|<&a>▲<&7>▼|up
            - inject <script> path:swap_hotbar
    swap_hotbar:
        # flag player with each inventory row
        - flag <player> <script.data_key[hotbar]>:<player.inventory.slot[1|2|3|4|5|6|7|8|9]>
        - flag <player> <script.data_key[row_one]>:<player.inventory.slot[10|11|12|13|14|15|16|17|18]>
        - flag <player> <script.data_key[row_two]>:<player.inventory.slot[19|20|21|22|23|24|25|26|27]>
        - flag <player> <script.data_key[row_three]>:<player.inventory.slot[28|29|30|31|32|33|34|35|36]>
        # remove current inventory (without armor and second hand slot)
        - inventory set o:<item[air].repeat_as_list[36]> slot:1
        # do the swapping
        - if <player.flag[<script.data_key[scroll_type]>]> == up:
            - inventory set o:<player.flag[<script.data_key[hotbar]>]> slot:28
            - inventory set o:<player.flag[<script.data_key[row_one]>]> slot:1
            - inventory set o:<player.flag[<script.data_key[row_two]>]> slot:10
            - inventory set o:<player.flag[<script.data_key[row_three]>]> slot:19
            - stop
        - else:
            - inventory set o:<player.flag[<script.data_key[hotbar]>]> slot:10
            - inventory set o:<player.flag[<script.data_key[row_one]>]> slot:19
            - inventory set o:<player.flag[<script.data_key[row_two]>]> slot:28
            - inventory set o:<player.flag[<script.data_key[row_three]>]> slot:1
            - stop

scrollable_inventory_task:
    type: task
    debug: false
    definitions: player|row_changed|scroll_type
    script:
        - ratelimit <[player]> 0.5s
        - flag <[player]> <script[scrollable_inventory_events].data_key[row_changed]>:<[row_changed]> expire:0.5s
        - flag <[player]> <script[scrollable_inventory_events].data_key[scroll_type]>:<[scroll_type]> expire:10s


#######################################
# offhand inventory
#######################################

swappable_offhand_events:
    type: world
    debug: true
    # flags
    inventory_contents: player.hud.swappable_inventory.inventory_contents
    temp_firstitem: player.hud.swappable_inventory.temp_firstitem
    inventory_open: player.hud.swappable_inventory.inventory_open
    inventory_doubleclick_test: player.hud.swappable_inventory.inventory_doubleclick_test
    # permissions
    use_offhand_scrolling: craftasy.denizen.hud.offhand_scroll
    # TODO: when player opens inventory, slot 3 will be updated with currently hold offhand item
    events:
        on player swaps items:
        # tests
        - if !<player.is_sneaking>:
            - stop
        - if !<player.has_permission[craftasy.denizen.hud.offhand_scroll]>:
            - stop
        - determine cancelled passively
        - flag <player> <script.data_key[inventory_doubleclick_test]>:++ expire:0.2s
        # test for double click action
        - if <player.flag[<script.data_key[inventory_doubleclick_test]>]> > 1:
            # open offhand inventory
            - inventory open d:swappable_offhand_inventory
            - flag <player> <script.data_key[inventory_open]>
        - else:
            - if !<player.has_flag[<script.data_key[inventory_contents]>]>:
                - stop
            - if <player.open_inventory> == <inventory[swappable_offhand_inventory]>:
                - narrate "<&c>offhand Inventar geöffnet"
                - stop
            - define firstitem <player.flag[<script.data_key[inventory_contents]>].get[1]>
            - flag <player> <script.data_key[temp_firstitem]>:<[firstitem]>
            - flag <player> <script.data_key[inventory_contents]>:<-:<player.flag[<script.data_key[temp_firstitem]>]>
            - flag <player> <script.data_key[inventory_contents]>:->:<player.flag[<script.data_key[temp_firstitem]>]>
            - flag <player> <script.data_key[temp_firstitem]>:!
            - adjust <player> item_in_offhand:<player.flag[<script.data_key[inventory_contents]>].get[1]>
            # cycle through offhand items in inventory
            - narrate "single click!"

        # add/remove items in offhand inventory
        on player closes swappable_offhand_inventory:
            - flag <player> <script.data_key[inventory_contents]>:<context.inventory.list_contents.exclude[<item[item_gui_filler_black]>]>
            - flag <player> <script.data_key[inventory_open]>:!
            - adjust <player> item_in_offhand:<player.flag[<script.data_key[inventory_contents]>].get[1]>
        on player opens swappable_offhand_inventory:
            - inventory set o:<player.item_in_offhand> slot:3
        # handling player interactions
        on player drags item_gui_filler_black in swappable_offhand_inventory:
        - determine cancelled
        on player clicks item_gui_filler_black in swappable_offhand_inventory:
        - determine cancelled


swappable_offhand_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: quick-menu
    procedural items:
    - define itemlist <player.flag[<script[swappable_offhand_events].data_key[inventory_contents]>].if_null[null]>
    - determine <[itemlist]>
    slots:
    - [item_gui_filler_black] [item_gui_filler_black] [] [] [] [] [] [item_gui_filler_black] [item_gui_filler_black]

item_gui_filler_black:
  type: item
  material: black_stained_glass_pane
  display name: <&sq>

