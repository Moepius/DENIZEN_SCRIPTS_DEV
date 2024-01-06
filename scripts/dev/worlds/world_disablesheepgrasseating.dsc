# disables sheeps eating grass in configured world

world_disablesheepgrasseating:
    type: world
    debug: false
    events:
        on sheep changes grass_block into dirt in:Avarus|orbis:
            - determine cancelled