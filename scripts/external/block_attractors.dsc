#| -- Block Attractors --
#|
#| @author acikek
#| @version 1.0.0
#| @date 22/4/22
#|
#| Use the 'gpickup' (gp) command when holding an item to create a Block Attractor!
#| Example: /gp vanilla_tagged:stairs 20
#|
#| The system is flag-based, allowing for items like the one below.

leaf_attractor:
  type: item
  material: green_dye
  display name: <green>Leaf Attractor
  lore:
  - <gray>Right-click to strip the leaves off of trees.
  flags:
    pickup:
      match: vanilla_tagged:leaves
      radius: 10

generate_pickup:
  type: command
  name: gpickup
  aliases:
  - gp
  description: Generates a block pickup item
  usage: /gpickup <&lt>match<&gt> (<&lt>radius<&gt>)
  tab completions:
    1: <server.vanilla_tags.parse_tag[vanilla_tagged:<[parse_value]>]>
    2: 1|5|10|20
  script:
  - if <player.item_in_hand.material.name> == air:
    - narrate "<red>You must be holding an item!"
    - stop
  - if <context.args.is_empty>:
    - narrate "<red>No matcher provided!"
    - stop
  - define radius <context.args.get[2].if_null[10]>
  - if !<[radius].is_decimal>:
    - narrate "<red>Radius must be a number!"
    - stop
  - define match <context.args.first>
  - define matches <server.material_types.filter_tag[<[filter_value].advanced_matches[<[match]>]>]>
  - if <[matches].is_empty>:
    - narrate "<red>No matching materials found!"
    - stop
  - define etc <[matches].size.is_more_than[1].if_true[...].if_false[<empty>]>
  - define name "<&color[<color[random]>]><[matches].random.translated_name><[etc]> Attractor"
  - inventory flag slot:hand pickup:<map[match=<[match]>;radius=<[radius]>]>
  - inventory adjust slot:hand display:<[name]>
  - inventory adjust slot:hand "lore:<gray>Matches <[match]>"
  - narrate "<green>Matched <yellow><[matches].size> <green>material(s)!"

block_pickup:
  type: task
  debug: false
  definitions: entity|match|radius
  script:
  - foreach <[entity].location.find_blocks[<[match]>].within[<[radius]>]> as:location:
    - spawn falling_block[fallingblock_type=<[location].material>] <[location].up[1]> save:block
    - define block <entry[block].spawned_entity>
    - modifyblock <[location]> air
    - adjust <[entity]> fake_pickup:<[block]>
    - remove <[block]>

block_pickup_handler:
  type: world
  debug: false
  events:
    after player right clicks block with:item_flagged:pickup:
    - define pickup <context.item.flag[pickup]>
    - if match not in <[pickup]>:
      - debug error "Item '<aqua><context.item.script.name><&r>' missing flag '<aqua>pickup.match<&r>'"
      - stop
    - define radius <[pickup].get[radius].if_null[10]>
    - run block_pickup def:<player>|<[pickup].get[match]>|<[radius]>
    on player places item_flagged:pickup:
    - determine cancelled