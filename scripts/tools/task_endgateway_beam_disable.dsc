task_endgateway_beam_disable:
    type: task
    debug: debug
    script:
        - note <player.location.add[-500,200,-500].to_cuboid[<player.location.add[500,-200,500]>]> as:temp_note
        - foreach <cuboid[temp_note].blocks[end_gateway]> as:blocks:
            - adjust <[blocks]> age:1000y
        - note remove as:temp_note