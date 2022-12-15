tool_autosave:
    type: world
    debug: false
    events:
        on delta time minutely every:30:
        - announce format:c_debug "Save und Backup aller Scripts gestartet ..."
        - announce to_console "Speichere Denizen und Citizens ..."
        - adjust server save
        - adjust server save_citizens