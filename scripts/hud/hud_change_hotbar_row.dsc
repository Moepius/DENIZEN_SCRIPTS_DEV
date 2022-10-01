# change hotbar row with sneak + scroll left/right
# TODO: add permissions/protection etc.
# TODO: do some

hotbar_row_events:
    type: world
    debug: true
    # flags
    row_changed: player.hud.hotbar_row.row_changed
    hotbar: player.hud.hotbar_row.current_hotbar
    next_row: player.hud.hotbar_row.next_row
    new_inventory: player.hud.hotbar_row.new_inventory

    # events
    events:
        on player scrolls their hotbar:
        - if !<player.is_sneaking>:
            - stop
        # "down" scroll
        - if <context.new_slot> > <context.previous_slot>:
            - determine cancelled passively
            - ratelimit <player> 0.5s
            - flag <player> <script.data_key[row_changed]>:<&7>▲<&a>▼ expire:0.5s
            #- flag <player> <script.data_key[hotbar]>:rowhere
        # "up" scroll
        - if <context.new_slot> < <context.previous_slot>:
            - determine cancelled passively
            - ratelimit <player> 0.5s
            - flag <player> <script.data_key[row_changed]>:<&a>▲<&7>▼ expire:0.5s
            #- flag <player> <script.data_key[hotbar]>:rowhere
        # create new inventory with new row in hotbar and old hotbar in row
        #- flag <player> <script.data_key[new_inventory]>:thenewinventory
        # adjust inventory to new inventory
        #- adjust <player.inventory> contents:<player.flag[<script.data_key[new_inventory]>]>
