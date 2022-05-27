commit_to_not_using_raw_object_notation_in_scripts:
    type: command
    name: enablehalo
    usage: /enablehalo
    description: Toggles your Halo for being a good Denizzle!
    aliases:
        - praisedenizen
    script:
        - if <player.has_flag[good_denizzle]>:
            - flag player good_denizzle:!
            - narrate "<&c>Your Halo disapears!"
        - else:
            - flag player good_denizzle
            - narrate "<&a>You become a good Denizzle!"
            - run good_denizzle_going_to_heaven

good_denizzle_going_to_heaven:
    type: task
    debug: false
    script:
        - define halo_color <color[255,255,0]>
        - while <player.has_flag[good_denizzle]> && <player.is_online>:
            - define pitch <player.location.pitch.to_radians>
            - define yaw <player.location.yaw.mul[-1].to_radians>
            - define loc <player.eye_location.below[0.2]>
            - define angle <location[0,0.6,0.25].rotate_around_y[<[loop_index].to_radians.mul[82]>].rotate_around_x[<[pitch]>].rotate_around_y[<[yaw]>]>
            - playeffect effect:redstone at:<[loc].add[<[angle]>]> offset:0 special_data:0.5|<[halo_color]>
            - if <[loop_index].mod[4]> == 0:
                - wait 1t
        - flag player good_denizzle:!
