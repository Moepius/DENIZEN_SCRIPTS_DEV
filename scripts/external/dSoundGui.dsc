# +--------------------
# |
# | dSoundGui
# |
# | Easily find the sound you need!
# |
# +----------------------
#
# @author Apademide
# @date 2021-09-12
# @denizen-build 1.2.1-b5752-DEV
# @script-version 1.0
#
# Installation:
# Place the following scripts in your scripts folder and reload:
#
# Usage:
#   Configure the GUI's settings if you want, or use the Superior Language aka French
#   This is not in the Drop-In-Ready section so it's NOT drop in ready to get
#   a 100% pretty ready-to-use GUI *DISPLAY*, but the core works as-is.
#
#   /soundgui or /sg to open the menu
#   requires "util.soundgui" permission
#
#   to all the people that'll tell me this script's a mess:
#   Yes. But it works. And it was a mess to make it work.
#   (especially the match-an-item-to-the-sound part)
#   And it's pretty cool to use.

# --------------------END HEADER / START CONFIG--------------------

soundgui_config:
  type: data
  debug: false
  # GUI's name
  GUI:
    NAME: <&[dark_gray]><bold>La Boîte à Musique
  BUTTONS:
    SOUND_BUTTONS:
      # The sounds buttons
      # <[PARSE_VALUE]> to get the sound's name (AMBIENT_NETHER_WASTES_MOOD for exemple)
      NAME: <&[yellow]><[PARSE_VALUE]>
      LORE:
      - <&[item_lore]>Cliquez pour jouer ce son.
    EDIT_PITCH:
      # The pitch button
      # Quick french class so you can translate it more easily:
      # (or at least understand)
      # clique = click
      # droit = right
      # central = middle
      # gauche = left
      # actuellement = now
      ITEM: paper
      NAME: <&[red]><bold>PITCH
      LORE:
      - <&[item_lore]>Clique droit: <&[item_description]>+0.1
      - <&[item_lore]>Clique central: <&[item_description]>1
      - <&[item_lore]>Clique gauche: <&[item_description]>-0.1
      - ""
      - <&[item_lore]>Actuellement: <&[item_description]><player.flag[SOUNDGUI.PITCH]>
    EDIT_VOLUME:
      # The volume button
      ITEM: paper
      NAME: <&[purple]><bold>VOLUME
      LORE:
      - <&[item_lore]>Clique droit: <&[item_description]>+0.1
      - <&[item_lore]>Clique central: <&[item_description]>1
      - <&[item_lore]>Clique gauche: <&[item_description]>-0.1
      - ""
      - <&[item_lore]>Actuellement: <&[item_description]><player.flag[SOUNDGUI.VOLUME]>
    EDIT_TARGET:
      # The target button
      # cibles = targets
      ITEM: name_tag
      NAME: <&[blue]><bold>CIBLES
      LORE:
      # joueur = player; only the player hears the sounds
      - <&[item_lore]>Clique gauche: <&[item_description]>Joueur
      - <&[orange]>Signifie que seul le joueur entend les sons
      # proximité = proximity; the players that are 32 blocks or closer to the player will hear
      - <&[item_lore]>Clique droit: <&[item_description]>À proximité
      - <&[orange]>Signifie que les joueurs dans un rayon
      - <&[orange]>de 32 blocs entendent les sons
      # en ligne = online; all online players will hear the sounds
      - <&[item_lore]>Clique central: <&[item_description]>En ligne
      - <&[orange]>Signifie que tous les joueurs
      - <&[orange]>en ligne entendent les sons
      - ""
      - <&[item_lore]>Actuellement: <&[item_description]><player.flag[SOUNDGUI.TARGET].equals[PLAYER].if_true[Joueur].if_false[<player.flag[SOUNDGUI.TARGET].equals[AREA].if_true[À proximité].if_false[En ligne]>]>
      ## don't forget to edit                                                                                 ^ this,                                                             ^ this                ^ and this
    EDIT_PAGE:
      # Tge pages button
      ITEM: book
      NAME: <&[orange]><bold>PAGE
      LORE:
      - <&[item_lore]>Clique droit: <&[item_description]>+1
      - <&[item_lore]>Clique central: <&[item_description]>1
      - <&[item_lore]>Clique gauche: <&[item_description]>-1
      - ""
      - <&[item_lore]>Actuellement: <&[item_description]><player.flag[SOUNDGUI.PAGE]>

# --------------------END CONFIG / START CODE--------------------

soundgui_command:
  type: command
  debug: false
  name: soundgui
  aliases:
  - sg
  - soundg
  description: open soundgui
  usage: /soundgui
  permission: util.soundgui
  script:
  - definemap DEFAULT_SETTINGS:
      PITCH: 1
      VOLUME: 1
      TARGET: PLAYER
      PAGE: 1
  - flag <player> SOUNDGUI:<[DEFAULT_SETTINGS]>
  - inventory open d:soundgui_inventory
soundgui_world:
  type: world
  debug: false
  WAT_DA_CLICK:
  - choose <context.click>:
    - case LEFT:
      - define CLICK LEFT
    - case RIGHT:
      - define CLICK RIGHT
    - case MIDDLE:
      - define CLICK MIDDLE
    - default:
      - stop
  UPDATE_DA_BUTTON:
  - inventory set d:<player.open_inventory> slot:<context.slot> o:<script[soundgui_config].data_key[BUTTONS.<[CATEGORY]>.ITEM].as_item.with_single[display=<script[soundgui_config].data_key[BUTTONS.<[CATEGORY]>.NAME].parsed>].with_single[lore=<script[soundgui_config].data_key[BUTTONS.<[CATEGORY]>.LORE].parse[parsed]>].with_flag[SOUNDGUI.TYPE:<[CATEGORY]>]>
  events:
    on player clicks in soundgui_inventory:
    - ratelimit <player> 2t
    - choose <context.item.flag[SOUNDGUI.TYPE].if_null[NULL]>:
      - case PLAYSOUND:
        - if <player.flag[SOUNDGUI.TARGET]> == PLAYER:
          - define TARGETS <list_single[<player>]>
        - else if <player.flag[SOUNDGUI.TARGET]> == AREA:
          - define TARGETS <player.location.find_entities[PLAYER].within[32]>
        - else if <player.flag[SOUNDGUI.TARGET]> == ONLINE:
          - define TARGETS <server.online_players>
        - else:
          - stop
        - adjust <[TARGETS]> stop_sound
        - playsound <[TARGETS]> sound:<context.item.flag[SOUNDGUI.SOUND]> volume:<player.flag[SOUNDGUI.VOLUME]> pitch:<player.flag[SOUNDGUI.PITCH]>
      - case EDIT_PITCH:
        - inject <script> path:WAT_DA_CLICK
        - choose <[CLICK]>:
          - case LEFT:
            - flag <player> SOUNDGUI.PITCH:<player.flag[SOUNDGUI.PITCH].sub[0.1].max[0]>
          - case RIGHT:
            - flag <player> SOUNDGUI.PITCH:<player.flag[SOUNDGUI.PITCH].add[0.1].min[2]>
          - case MIDDLE:
            - flag <player> SOUNDGUI.PITCH:1
        - define CATEGORY EDIT_PITCH
        - inject <script> path:UPDATE_DA_BUTTON
      - case EDIT_VOLUME:
        - inject <script> path:WAT_DA_CLICK
        - choose <[CLICK]>:
          - case LEFT:
            - flag <player> SOUNDGUI.VOLUME:<player.flag[SOUNDGUI.VOLUME].sub[0.1].max[0]>
          - case RIGHT:
            - flag <player> SOUNDGUI.VOLUME:<player.flag[SOUNDGUI.VOLUME].add[0.1].min[5]>
          - case MIDDLE:
            - flag <player> SOUNDGUI.VOLUME:1
        - define CATEGORY EDIT_VOLUME
        - inject <script> path:UPDATE_DA_BUTTON
      - case EDIT_TARGET:
        - inject <script> path:WAT_DA_CLICK
        - choose <[CLICK]>:
          - case LEFT:
            - flag <player> SOUNDGUI.TARGET:PLAYER
          - case RIGHT:
            - flag <player> SOUNDGUI.TARGET:AREA
          - case MIDDLE:
            - flag <player> SOUNDGUI.TARGET:ONLINE
        - define CATEGORY EDIT_TARGET
        - inject <script> path:UPDATE_DA_BUTTON
      - case EDIT_PAGE:
        - inject <script> path:WAT_DA_CLICK
        - choose <[CLICK]>:
          - case LEFT:
            - flag <player> SOUNDGUI.PAGE:<player.flag[SOUNDGUI.PAGE].sub[1].max[1]>
          - case RIGHT:
            - flag <player> SOUNDGUI.PAGE:<player.flag[SOUNDGUI.PAGE].add[1].min[50]>
          - case MIDDLE:
            - flag <player> SOUNDGUI.PAGE:1
        - inventory open d:soundgui_inventory
soundgui_inventory:
  type: inventory
  debug: false
  inventory: CHEST
  title: <&f><&l><script[soundgui_config].parsed_key[GUI.NAME]>
  size: 54
  gui: true
  procedural items:
  - define PAGE <player.flag[SOUNDGUI.PAGE]>
  - define FROM <[PAGE].sub[1].mul[24].add[1]>
  - define TO <[PAGE].mul[24]>
  - define SOUNDS <server.sound_types.get[<[FROM]>].to[<[TO]>]>
  - define DATA <script[soundgui_config].data_key[BUTTONS]>
  - define EDIT_PITCH <[DATA].deep_get[EDIT_PITCH.ITEM].as_item.with_single[display=<[DATA].deep_get[EDIT_PITCH.NAME].parsed>].with_single[lore=<[DATA].deep_get[EDIT_PITCH.LORE].parse[parsed]>].with_flag[SOUNDGUI.TYPE:EDIT_PITCH]>
  - define EDIT_VOLUME <[DATA].deep_get[EDIT_VOLUME.ITEM].as_item.with_single[display=<[DATA].deep_get[EDIT_VOLUME.NAME].parsed>].with_single[lore=<[DATA].deep_get[EDIT_VOLUME.LORE].parse[parsed]>].with_flag[SOUNDGUI.TYPE:EDIT_VOLUME]>
  - define EDIT_TARGET <[DATA].deep_get[EDIT_TARGET.ITEM].as_item.with_single[display=<[DATA].deep_get[EDIT_TARGET.NAME].parsed>].with_single[lore=<[DATA].deep_get[EDIT_TARGET.LORE].parse[parsed]>].with_flag[SOUNDGUI.TYPE:EDIT_TARGET]>
  - define EDIT_PAGE <[DATA].deep_get[EDIT_PAGE.ITEM].as_item.with_single[display=<[DATA].deep_get[EDIT_PAGE.NAME].parsed>].with_single[lore=<[DATA].deep_get[EDIT_PAGE.LORE].parse[parsed]>].with_flag[SOUNDGUI.TYPE:EDIT_PAGE]>
  - determine <[SOUNDS].parse_tag[<[PARSE_VALUE].proc[soundgui_itemproc].as_item.with_single[display=<[DATA].deep_get[SOUND_BUTTONS.NAME].parsed>].with_single[lore=<[DATA].deep_get[SOUND_BUTTONS.LORE].parse[parsed]>].with_flag[SOUNDGUI:<map[TYPE=PLAYSOUND;SOUND=<[PARSE_VALUE]>]>]>].pad_right[24].with[air].insert[<[EDIT_PITCH]>].at[7].insert[<[EDIT_VOLUME]>].at[14].insert[<[EDIT_TARGET]>].at[21].insert[<[EDIT_PAGE]>].at[28]>
  slots:
  - [air] [air] [air] [air] [air] [air] [air] [air] [air]
  - [air] [] [] [] [] [] [] [] [air]
  - [air] [] [] [] [] [] [] [] [air]
  - [air] [] [] [] [] [] [] [] [air]
  - [air] [] [] [] [] [] [] [] [air]
  - [air] [air] [air] [air] [air] [air] [air] [air] [air]
soundgui_itemproc:
  type: procedure
  definitions: SOUND
  debug: false
  script:
  - choose <[SOUND].before[_]>:
    - case BLOCK:
      - determine <script.data_key[data.BLOCKS.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.BLOCKS.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches_text[*<[SOUND].after[BLOCK_].before[_]>*]>].first>]>
    - case ENTITY:
      - determine <script.data_key[data.ENTITIES.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.ENTITIES.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches_text[*<[SOUND].after[ENTITY_].before[_]>*]>].first>]>
    - case ITEM:
      - determine <script.data_key[data.ITEMS.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.ITEMS.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches_text[*<[SOUND].after[ITEM_].before[_]>*]>].first>]>
    - default:
      - if <material[<[SOUND]>].is_item.if_null[false]>:
        - determine <[SOUND]>
      - determine NOTE_BLOCK
  data:
    ITEMS:
      CUSTOMS:
        ITEM_CROP_PLANT: wheat
        ITEM_FIRECHARGE_USE: fire_charge
        ITEM_FLINTANDSTEEL_USE: flint_and_steel
      MATERIALS:
      - armor_stand
      - waxed_copper_block
      - bone_block
      - bookshelf
      - glass_bottle
      - bucket
      - chorus_plant
      - crossbow
      - white_dye
      - elytra
      - glowstone
      - wooden_hoe
      - honeycomb
      - honey_block
      - pink_wool
      - lodestone
      - nether_gold_ore
      - shield
      - wooden_shovel
      - spyglass
      - totem_of_undying
      - trident
    ENTITIES:
      CUSTOMS:
        ENTITY_GENERIC_BIG_FALL: leather_boots
        ENTITY_GENERIC_BURN: flint_and_steel
        ENTITY_GENERIC_DEATH: iron_sword
        ENTITY_GENERIC_DRINK: glass_bottle
        ENTITY_GENERIC_EAT: cooked_beef
        ENTITY_GENERIC_EXPLODE: tnt
        ENTITY_GENERIC_EXTINGUISH_FIRE: flint_and_steel
        ENTITY_GENERIC_HURT: iron_sword
        ENTITY_GENERIC_SMALL_FALL: leather_boots
        ENTITY_GENERIC_SPLASH: water_bucket
        ENTITY_GENERIC_SWIM: water_bucket
        ENTITY_HOSTILE_BIG_FALL: leather_boots
        ENTITY_HOSTILE_DEATH: iron_sword
        ENTITY_HOSTILE_HURT: iron_sword
        ENTITY_HOSTILE_SMALL_FALL: leather_boots
        ENTITY_HOSTILE_SPLASH: water_bucket
        ENTITY_HOSTILE_SWIM: water_bucket
        ENTITY_ILLUSIONER_AMBIENT: splash_potion
        ENTITY_ILLUSIONER_CAST_SPELL: splash_potion
        ENTITY_ILLUSIONER_DEATH: splash_potion
        ENTITY_ILLUSIONER_HURT: splash_potion
        ENTITY_ILLUSIONER_MIRROR_MOVE: splash_potion
        ENTITY_ILLUSIONER_PREPARE_BLINDNESS: splash_potion
        ENTITY_ILLUSIONER_PREPARE_MIRROR: splash_potion
        ENTITY_LEASH_KNOT_BREAK: lead
        ENTITY_LEASH_KNOT_PLACE: lead
      MATERIALS:
      - armor_stand
      - arrow
      - axolotl_bucket
      - bat_spawn_egg
      - beef
      - blaze_rod
      - oak_boat
      - cat_spawn_egg
      - chicken
      - cod_bucket
      - cow_spawn_egg
      - creeper_spawn_egg
      - dolphin_spawn_egg
      - donkey_spawn_egg
      - dragon_egg
      - drowned_spawn_egg
      - elder_guardian_spawn_egg
      - enderman_spawn_egg
      - endermite_spawn_egg
      - ender_chest
      - evoker_spawn_egg
      - experience_bottle
      - firework_rocket
      - fishing_rod
      - pufferfish_bucket
      - fox_spawn_egg
      - ghast_tear
      - glowstone
      - goat_spawn_egg
      - hoglin_spawn_egg
      - horse_spawn_egg
      - husk_spawn_egg
      - iron_ore
      - item_frame
      - lightning_rod
      - lingering_potion
      - llama_spawn_egg
      - magma_block
      - minecart
      - mooshroom_spawn_egg
      - mule_spawn_egg
      - ocelot_spawn_egg
      - painting
      - panda_spawn_egg
      - parrot_spawn_egg
      - phantom_spawn_egg
      - piglin_spawn_egg
      - pig_spawn_egg
      - pillager_spawn_egg
      - player_head
      - polar_bear_spawn_egg
      - rabbit_spawn_egg
      - ravager_spawn_egg
      - salmon_bucket
      - sheep_spawn_egg
      - shulker_box
      - silverfish_spawn_egg
      - skeleton_spawn_egg
      - slime_block
      - snowball
      - snow
      - spider_eye
      - splash_potion
      - glow_squid_spawn_egg
      - stray_spawn_egg
      - strider_spawn_egg
      - tnt
      - tropical_fish_bucket
      - turtle_egg
      - vex_spawn_egg
      - villager_spawn_egg
      - vindicator_spawn_egg
      - wandering_trader_spawn_egg
      - witch_spawn_egg
      - wither_rose
      - wolf_spawn_egg
      - zoglin_spawn_egg
      - zombie_spawn_egg
      - zombified_piglin_spawn_egg
    BLOCKS:
      CUSTOMS:
        BLOCK_CROP_BREAK: wheat
        BLOCK_BLASTFURNACE_FIRE_CRACKLE: blast_furnace
        BLOCK_ENCHANTMENT_TABLE_USE: enchanting_table
        BLOCK_METAL_BREAK: iron_block
        BLOCK_METAL_FALL: iron_block
        BLOCK_METAL_HIT: iron_block
        BLOCK_METAL_PLACE: iron_block
        BLOCK_METAL_PRESSURE_PLATE_CLICK_OFF: iron_block
        BLOCK_METAL_PRESSURE_PLATE_CLICK_ON: iron_block
        BLOCK_METAL_STEP: iron_block
      MATERIALS:
      - amethyst_block
      - ancient_debris
      - anvil
      - azalea_leaves
      - bamboo
      - barrel
      - basalt
      - beacon
      - beehive
      - bell
      - big_dripleaf
      - bone_block
      - brewing_stand
      - dead_bubble_coral_block
      - cake
      - calcite
      - campfire
      - candle
      - cave_spider_spawn_egg
      - chain
      - chest
      - chorus_plant
      - comparator
      - composter
      - conduit
      - copper_ore
      - dead_tube_coral_block
      - deepslate
      - dispenser
      - dripstone_block
      - ender_chest
      - end_rod
      - oak_fence
      - dead_fire_coral_block
      - flowering_azalea_leaves
      - crimson_fungus
      - furnace
      - gilded_blackstone
      - glass
      - grass_block
      - gravel
      - grindstone
      - hanging_roots
      - honey_block
      - iron_ore
      - ladder
      - jack_o_lantern
      - large_fern
      - lava_bucket
      - lever
      - lily_of_the_valley
      - lodestone
      - medium_amethyst_bud
      - moss_carpet
      - netherite_block
      - netherrack
      - nether_gold_ore
      - note_block
      - crimson_nylium
      - piston
      - pointed_dripstone
      - polished_granite
      - end_portal_frame
      - white_concrete_powder
      - pumpkin
      - redstone_ore
      - respawn_anchor
      - rooted_dirt
      - crimson_roots
      - sand
      - scaffolding
      - sculk_sensor
      - shroomlight
      - shulker_box
      - slime_block
      - small_dripleaf
      - smithing_table
      - smoker
      - snow
      - soul_sand
      - spore_blossom
      - crimson_stem
      - stone
      - sweet_berries
      - tripwire_hook
      - tuff
      - weeping_vines
      - nether_wart_block
      - water_bucket
      - wet_sponge
      - wooden_sword
      - stripped_oak_wood
      - white_wool
#END