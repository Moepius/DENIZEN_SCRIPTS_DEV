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

###################  PLANNED CHANGES #####################

## Rework of beds:
# beds will no longer set the spawn location of the player, players always respawn in hortus manium except they have a special item
# beds will no longer skip the night
# beds will restore health over time and heal negative effects over time, also they restore sanity

## Food/Hunger:
# a full hunger bar won't heal players automatically, except they have a mastery in farming/cooking
# other positive effects for a full hunger bar, faster walking, bonus critcal change when fighting, etc.
# certain types of food will give buffs
# change exhaustion level by skill ... https://meta.denizenscript.com/Docs/Search/sprint#playertag.exhaustion

## weather/seasons:
# add seasons which have different effects on weather, NPCs and day/night cycle
# adjust day night cycle by season and make them longer in general
# have a "year" counter that counts the ingame years
# more weather effects
# crops don't grow in winter and grow faster in summer

## Farming:
# cows and other breedable animals need much longer to grow up, the higher the players skill the faster they grow
# milking cows has a cooldown of 24 ingame hours
# crops and other plants need much longer to grow
# restrict automatic farming: breaking crops by hand gives xp + the item, braking it via block rewards no xp and decreases yield drastically (e.g. only 1/4 of the broken block drop a crop)

## Experience:
# every action that rewards players with experience drops orbs, even custom ones
# to buy skills you have to spend experience points
# getting better at a specific task (farming, killing mobs, etc.) will reward players with more experience over time
# decrease experience earned by killing mobs drastically




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
  debug: false
  enabled: true
  events:
    after player places block:
    # TODO: check for creative mode and dcreative
    # intial checks
    - if <player.gamemode> == creative:
      - stop
    - define item <context.item_in_hand>
    - if <context.item_in_hand.quantity> != 1 || !<player.inventory.contains_item[<[item].material.name>]>:
      - stop

    - define items <player.inventory.map_slots.filter_tag[<[filter_value].advanced_matches[<[item].material.name>]>]>
    - define max <[item].max_stack>
    - define quantity 0

    - foreach <[items]>:

      #stop if desired quantity
      - if <[quantity]> == <[max]>:
        - foreach stop

      #if current + looped quantity is less or equals than max quantity
      - if <[value].quantity.add[<[quantity]>]> <= <[max]>:
        - take slot:<[key]> quantity:<[value].quantity>
        - define quantity:+:<[value].quantity>

      #if current + looped quantity is more than max quantity
      - else if <[value].quantity.add[<[quantity]>]> > <[max]>:
        #looped + current - max (eg. 60 + 5 - 64)
        - define leftover <[value].quantity.add[<[quantity]>].sub[<[max]>]>

        - take slot:<[key]> quantity:<[value].quantity.sub[<[leftover]>]>
        - define quantity:+:<[value].quantity.sub[<[leftover]>]>

    - inventory set o:<[item].with[quantity=<[quantity]>]> slot:<context.hand.replace[_]>

##### makes players walk faster on dirt paths
# TODO: test for creative/dcreative
# TODO: more use cases on "offical streets"
pathblock_speed_boost:
  type: world
  debug: false
  enabled: true
  events:
    after player steps on dirt_path in:orbis|avarus flagged:!pathblock_speed_boost.active:
      - ratelimit <player> 0.5s
      - adjust <player> speed:0.11
      - flag <player> pathblock_speed_boost.active
    after player steps on !dirt_path in:orbis|avarus flagged:pathblock_speed_boost.active:
      - ratelimit <player> 0.5s
      - flag <player> pathblock_speed_boost.active:!
      - adjust <player> speed:0.1

dropcancels:
    type: world
    debug: false
    events:
        on mob dies in:orbis:
            - determine NO_DROPS
        on mob dies in:world|avarus:
            - determine NO_DROPS


# disables sheeps eating grass in configured world
world_disablesheepgrasseating:
    type: world
    debug: false
    events:
        on sheep changes grass_block into dirt in:Avarus|orbis:
            - determine cancelled
