sneak_on_radius_npc:
    type: assignment
    debug: false
    actions:
        on assignment:
        - trigger name:proximity state:true radius:15
        on spawn:
        - wait 1t
        - sneak <list[<npc>].include[<npc.name_hologram_npc||<list>>].include[<npc.hologram_npcs||<list>>].filter[is_spawned]> start fake
        on enter proximity:
        - sneak <list[<npc>].include[<npc.name_hologram_npc||<list>>].include[<npc.hologram_npcs||<list>>].filter[is_spawned]> stop fake for:<player>
        on exit proximity:
        - sneak <list[<npc>].include[<npc.name_hologram_npc||<list>>].include[<npc.hologram_npcs||<list>>].filter[is_spawned]> start fake for:<player>