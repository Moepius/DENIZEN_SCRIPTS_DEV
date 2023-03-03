vacuum_placeholder_item:
  type: item
  material: stick
  display name: <&3><&l>[<&6><&l>Test (Vakuum Angriff)<&3><&l>]
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:4
  lore:
    - test item
    - <&c>Admin Tool


Vorpal_Vacuum_Charge:
    type: world
    debug: false
    events:
        on player right clicks block with:vacuum_placeholder_item:
        - determine passively cancelled
        - flag <player> vorpal_vacuum_charging:true
        # TODO: debug entfernen
        - narrate format:c_debug "Angriff lädt auf"
        - run Vorpal_Vacuum_Charging_Sound
        - run Vorpal_Vacuum_Charged_Notification
        - while <player.has_flag[vorpal_vacuum_charging]>:
            - cast slow amplifier:2 duration:1s hide_particles no_icon
            - run Vorpal_Vacuum_Charging_Particles
            - wait 5t
        on player left clicks block with:vacuum_placeholder_item:
        - determine passively cancelled
        # TODO: debug entfernen
        - narrate format:c_debug "Angriff gestartet"
        #- narrate "<context.id> key released"
        - flag <player> vorpal_vacuum_charging:!
        - flag <player> vorpal_vacuum_charge_notified:!
        - adjust <player> stop_sound:minecraft:item.elytra.flying
        - cast slow remove <player>
        - flag <player> vorpal_vacuum_cooldown expire:1s
        - run Vorpal_Vacuum_Begin
        - run Vorpal_Vacuum_Impact_Tracker
        - if <player.is_on_ground.not>:
            # TODO: debug entfernen
            - narrate format:c_debug "Spieler in der Luft"
            #- narrate "Reactivated Vorpal Vacuum in the air"
            #- narrate "Plunging attack triggered"
            - flag <player> vorpal_vacuum_plunging expire:10s
            - adjust <player> velocity:0,-2,0
            - playsound <player> sound:entity_illusioner_cast_spell pitch:1.2 volume:0.6
       # on player right clicks block with:vacuum_placeholder_item flagged:vorpal_vacuum_activated:
       # - determine passively cancelled

Vorpal_Vacuum_Charged_Notification:
    type: task
    debug: false
    speed: 0
    script:
    - wait 1s
    - if <player.has_flag[vorpal_vacuum_charging]>:
        - playsound <player> sound:block_note_block_chime pitch:2

Vorpal_Vacuum_Charging_Sound:
    type: task
    debug: false
    speed: 0
    script:
    - while <player.has_flag[vorpal_vacuum_charging]>:
        - playsound <player> sound:item_elytra_flying pitch:2 volume:0.6
        - wait 4s

Vorpal_Vacuum_Charging_Particles:
    type: task
    debug: false
    speed: 0
    script:
    - define 2pi <util.pi.mul[2]>
    - define cast_location <player.location.with_yaw[90].with_pitch[0]>
    - define first_point <player.location.forward_flat[15].above[1].with_yaw[90].with_pitch[0]>
    - define vector <[first_point].sub[<[cast_location]>]>
    - define point_list <list>
    - define points 20
    - repeat 20:
        - define point_location <[vector].rotate_around_y[<[2pi].div[20].mul[<[value]>]>]>
        - define point_list <[point_list].include[<[cast_location].add[<[point_location]>]>]>
    - repeat 2:
        - foreach <[point_list].random[4]>:
            - playeffect effect:cloud at:<[value]> visibility:50 quantity:4 offset:2.1,1.1,2.1 velocity:<[cast_location].sub[<[value]>].normalize>
        - wait 2t

Vorpal_Vacuum_Begin:
    type: task
    debug: false
    speed: 0
    script:
    #- narrate "Vorpal Vacuum activated"
    - run Vorpal_Vacuum_Target_Gather
    # Establish the cast location
    - define cast_location <player.location>
    - flag <player> vorpal_vacuum_activated expire:2s
    - playsound <player> sound:entity_illusioner_cast_spell pitch:1 volume:0.6
    - adjust <player> velocity:0,1.5,0

Vorpal_Vacuum_Impact_Tracker:
    type: task
    debug: false
    speed: 0
    script:
    - wait 0.5s
    - while <player.has_flag[vorpal_vacuum_activated]>:
        # If the player is standing on the ground
        - if <player.is_on_ground>:
            - flag <player> vorpal_vacuum_activated:!
            - if <player.has_flag[vorpal_vacuum_plunging]>:
                - run Vorpal_Vacuum_Plunge_Attack
                - playsound <player> sound:ENTITY_wither_break_block pitch:0.1 volume:0.6
                - playsound <player> sound:ENTITY_wither_shoot pitch:0.1 volume:0.6
                - playeffect effect:cloud at:<player.location.above[0.2]> visibility:50 quantity:50 offset:1.0,1.0,1.0 data:1
                #- narrate "Impact detected"
        - wait 3t
        # Stop the loop from lasting too long
        - define count:++
        - if <[count]> >= 20:
            - stop

Vorpal_Vacuum_Plunge_Attack:
    type: task
    debug: true
    speed: 0
    script:
    # Establish the cast location
    - define cast_location <player.location>
    # Check whether key was held long enough
    # TODO: checks einbauen ob Ladezeit eingehalten wurde
    # Replace damage with proc script later on
    - define damage 25
    # Vacuum range
    - define radius 8
    # Particle quantity
    - define quantity 40
    # Upward velocity at end of vacuum
    - define throw 0.7
    # Build a list of enemies in range
    - define targets <[cast_location].find_entities.within[<[radius]>].exclude[<player>]>
    # Suck in the targets
    - repeat 4:
        - playeffect effect:cloud at:<[cast_location].above[2]> visibility:50 quantity:<[quantity]> offset:1.0,1.0,1.0 data:1
        - foreach <[targets]> as:target:
            - adjust <[target]> velocity:<[target].location.face[<[cast_location].above[1.5]>].direction.vector.div[4]>
        - wait 2t
    - hurt <[damage]> <[targets]> source:<player>
    - foreach <[targets]> as:target:
        - adjust <[target]> velocity:0,<[throw]>,0


Vorpal_Vacuum_Target_Gather:
    type: task
    debug: false
    speed: 0
    script:
    # Establish the cast location
    - define cast_location <player.location>
    # Check whether key was held
    - define radius 10
    - define iterations 8
    # Build a list of enemies in range
    # TODO: case: no targets found?
    - define targets <[cast_location].find_entities.within[<[radius]>].exclude[<player>]>
    # Suck in the targets
    - repeat <[iterations]>:
        - playeffect effect:cloud at:<[cast_location].above[2]> visibility:25 quantity:10 offset:1.0,1.0,1.0 data:1
        - foreach <[targets]> as:target:
            - adjust <[target]> velocity:<[target].location.face[<[cast_location].above[1.5]>].direction.vector.div[2]>
        - wait 2t