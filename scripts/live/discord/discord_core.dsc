

# server startup

connect_to_discord:
    type: world
    events:
        after server start:
        - ~discordconnect id:craftasybot token:<secret[discord_bot_secret]>