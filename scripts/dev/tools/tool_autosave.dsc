tool_autosave:
    type: world
    debug: false
    events:
        on delta time minutely every:30:
        - announce to_console "Speichere Denizen und Citizens ..."
        - adjust server save
        - adjust server save_citizens