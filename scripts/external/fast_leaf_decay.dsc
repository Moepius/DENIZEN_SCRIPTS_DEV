fast_leaf_decay_config:
    type: data

    # Whitelist of worlds where fast leaf decay will be active
    worlds:
        - world
        - parallelwelt

    # If true then worlds list is a blacklist (i.e. fast leaf decay active except in these worlds)
    worlds_is_blacklist: false


fast_leaf_decay:
    type: world
    definitions: loc|mat
    debug: false
    events:
        on leaves decay:
        - if !<script[fast_leaf_decay_config].data_key[worlds_is_blacklist]> && !<script[fast_leaf_decay_config].data_key[worlds].contains[<context.location.world.name>]>:
            - stop
        - if <script[fast_leaf_decay_config].data_key[worlds_is_blacklist]> && <script[fast_leaf_decay_config].data_key[worlds].contains[<context.location.world.name>]>:
            - stop
        - determine passively cancelled
        #All nearby leaves touching the one that decayed...
        - define decaying_leaves <context.location.find_blocks[*_leaves].within[10]>
        #Excluding any that are within 6 blocks of a log that they are touching...
        - define decaying_leaves <[decaying_leaves].filter[tree_distance.is_more_than[6]]>
        #Excluding persistent leaves...
        - define decaying_leaves <[decaying_leaves].filter[material.persistent.not]>
        #Excluding ones that have already been flagged, so they don't try to 'decay' twice...
        - define decaying_leaves <[decaying_leaves].filter[has_flag[decaying].not]>
        - foreach <[decaying_leaves]>:
            - flag <[value]> decaying expire:1m
            - run fast_leaf_decay path:remove def:<[value]>|<[value].material.name> delay:<util.random.int[1].to[<[loop_index]>]>t
    remove:
    #If someone were to quickly replace a leaf block with something else, that block won't be deleted.
    - if <[mat]> == <[loc].material.name>:
        - modifyblock <[loc]> air naturally:wooden_hoe
        - flag <[loc]> decaying:!


# TODO: [02:13:07] [Server thread/INFO]:  ERROR in script 'fast_leaf_decay' in queue 'FAST_LEAF_DECAY_241738_PsycholynxIndices' while executing command 'DEFINE' in file 'scripts/EXTERN/fast_leaf_decay.dsc' on line '27'!
# Error Message: locationtag.tree_distance is deprecated in favor of location.material.distance ... Enable debug on the script for more information. 
# [02:13:17] [Server thread/INFO]: FroherFrosch issued server command: //undo
