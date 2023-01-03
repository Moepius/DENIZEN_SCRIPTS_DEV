# event handler to listen for global events that involve multiple scripts and core features

core_listener:
    type: world
    debug: false
    enabled: true
    events:
        # stops all custom items with flag "no_crafting" from beeing used in recipes
        on item recipe formed:
        - if <context.inventory.matrix.filter[flagged[no_crafting]].size> > 0:
            - narrate format:c_debug "core_listener: on item recipe formed flagged[no_crafting] ausgelöst."
            - determine cancelled