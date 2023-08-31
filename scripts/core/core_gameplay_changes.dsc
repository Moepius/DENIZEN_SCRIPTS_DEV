# TODO: Disable elytra flying with rockets in survival worlds
# TODO: Make phantom spawning more fun (less frequent, random spawns not as punishment for not sleeping)
# TODO: make Mending much harder to get
# TODO: disable villager spawning/trading in building worlds (orbis/avarus)
# TODO: make mobs faster, so they can keep up with players who sprint
# TODO: nerf beds in farming worlds, no skipping night in building worlds (orbis/avarus), beds don't set spawn point
# TODO: beds give "well rested" status effect for sleeping for a set amount of time, cure some negative staus effects
# TODO: buff rails (less expensive crafting recipes, faster traveling)
# TODO: sync world times
# TODO: chance for "bloodmoon" like events (negative, longer nights) and blessed days (positive, longer day, e. g. crops grow faster)
# TODO: when a stack of an item is used up, the hotbarslot is refilled with that item automatically if player has more in inventory
# TODO: https://www.curseforge.com/minecraft/mc-mods/tweakeroo implementieren
# TODO: Players can place buttons, pressure plates etc. on fences and walls  with sound

# https://meta.denizenscript.com/Docs/Events/time%20changes%20in%20world

# https://meta.denizenscript.com/Docs/Search/time

core_gameplay:
    type: world
    enabled: false
    events:
        on player joins:
        - if <player.has_flag[enabled_error]>:
            - narrate "Fehler! Script sollte ausgeschaltet sein"

core_pickupheads:
    type: world
    events:
        after player inventory slot changes to:player_head:
        #TODO: add custom creative mode to test
        - if <player.gamemode> != creative:
            - stop
        - define skin <player.cursor_on.skull_skin.full||null>
        - if <[skin]> == null:
            - stop
        - inventory set o:<item[player_head].with[skull_skin=<[skin]>]> slot:<context.slot>


# allows placing of "hanging" blocks in need of support like ladders, and allows plant items to be placed on more blocks than sil types
cancel_physics:
  type: world
  debug: false
  events:
# Changes the block that was clicked to the item that is currently held (grass/fern)
    after player right clicks stone|cobblestone|gravel|stone_bricks|cracked_stone_bricks|andesite with:grass|tall_grass|dead_bush|fern:
    - if <player.has_permission[craftasy.denizen.dblock.physicscancel]>:
      - modifyblock <context.location.up> <player.item_in_hand.material.name>
      - take iteminhand quantity:1
    - else:
      - stop
# disables block physics (dropping the item), unless the supporting block is removed
    on grass|fern physics:
    - if <context.location.below.material.name> == air:
      - stop
    - else:
      - determine cancelled

#disables physics for ladders, rails and carpets (breaking)
    on rail physics:
      - determine cancelled
    on block physics adjacent:ladder|*_carpet:
      - determine cancelled

# With rightcklick + sneaking, players can open a shulker box from their inventory. Kinda like a backpack.
rightclick_shulker_inventory:
    type: world
    debug: false
    events:
        on player right clicks block with:*_shulker_box|shulker_box:
          - if <player.is_sneaking>:
            - determine cancelled passively
            - playsound <player.location> sound:block_shulker_box_open
            - inventory open "d:generic[title=<player.item_in_hand.display.if_null[Shulker Box]>;contents=<player.item_in_hand.inventory_contents>]"
            - flag <player> shulker_box
        on player flagged:shulker_box drops *_shulker_box|shulker_box:
          - determine cancelled
        on player flagged:shulker_box closes inventory:
          - define items <context.inventory.list_contents>
          - inventory adjust slot:hand inventory_contents:<[items]>
          - flag <player> shulker_box:!
        on player flagged:shulker_box drags *_shulker_box|shulker_box:
          - determine cancelled
        on player flagged:shulker_box drags in inventory:
          - if <context.item.advanced_matches[shulker_box|*_shulker_box]>:
            - determine cancelled
        on player flagged:shulker_box clicks in inventory:
          - if <context.item.advanced_matches[shulker_box|*_shulker_box]>:
            - determine cancelled

refill_blocks:
  type: world
  debug: true
  enabled: true
  events:
    on player places block:
      - if <player.gamemode> != survival:
            - stop
      - if <context.item_in_hand.quantity> == 1:
        - flag <player> refill_blocks:<context.item_in_hand>
    after player places block flagged:refill_blocks:
      - if !<player.inventory.contains_item[<player.flag[refill_blocks].material>]>:
        - stop
      - if <player.item_in_hand.material.name> != air:
        - stop
      - foreach <player.inventory.find_all_items[<player.flag[refill_blocks].material>]> as:slot:
        # get material names and quantities list
        # sort the list by size
        # give player
        # refill the players item in hand slot with item from refill_blocks flag, up to 64
        # remove the items from the inventory slots they where taken from
