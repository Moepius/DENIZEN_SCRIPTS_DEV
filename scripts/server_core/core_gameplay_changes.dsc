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




# https://meta.denizenscript.com/Docs/Events/time%20changes%20in%20world

# https://meta.denizenscript.com/Docs/Search/time

core_gameplay:
    type: world
    enabled: false
    events:
        on player joins:
        - if <player.has_flag[enabled_error]>:
            - narrate "Fehler! Script sollte ausgeschaltet sein"

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

#disables physics for ladders and rails (breaking)
    on rail physics:
      - determine cancelled
    on block physics adjacent:ladder|*_carpet:
      - determine cancelled

