# obelisk script, that lets you teleport between obelisks in a world at the cost of experience points

### eye of ender handler
# changes the location that eyes of ender point to, to the next obelisk in orbis
end_eye_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player right clicks block with:ender_eye in:orbis:
            - spawn ENDER_SIGNAL[ender_eye_target_location=endereye_test] <player.location.add[0,1,0]>