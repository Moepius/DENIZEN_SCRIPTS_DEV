#
# dBlockPhysicsCancelScript
# author: Moepius
# version: 1.0.0
#
# READ ME
# this script allows grass/fern to be placed on more blocks than just dirt/grass, while
# also keeping minecrafts default behaviour of breaking the block if the supporting block is removed.
# Rails and ladders won't break, if the supporting block is removed by a player.
# Uses permission "dblock.physicscancel" to be able to sell ability in servershop.
# disabling ladder/rail physics on by default, no permission needed.
#



dBlockPhysicsCancelScript:
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
    on block physics adjacent:ladder:
      - determine cancelled