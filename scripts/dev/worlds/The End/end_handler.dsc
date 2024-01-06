
end_handler:
    type: world
    events:
        on player breaks block in:kaos:
            - if !<player.has_flag[player.worlds.the_end.can_break_blocks]>:
                - determine cancelled passively
                - playeffect effect:smoke at:<context.location.above> visibility:100 quantity:7 velocity:0,0.1,0 offset:2.0
                - playeffect effect:soul at:<context.location.above> visibility:100 quantity:15 velocity:0,0.1,0 offset:2.0
                - playsound <player> sound:particle_soul_escape volume:5
            - else:
                - stop
        on player places block in:kaos:
            - if !<player.has_flag[player.worlds.the_end.can_place_blocks]>:
                - determine cancelled passively
                - playeffect effect:smoke at:<context.location> visibility:100 quantity:7 velocity:0,0.1,0 offset:2.0
                - playeffect effect:soul at:<context.location> visibility:100 quantity:15 velocity:0,0.1,0 offset:2.0
                - playsound <player> sound:particle_soul_escape volume:5
            - else:
                - stop

                #TODO: also prevent placement of item frames etc