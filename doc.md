# Documentation

## Config

## Commands

## Tools

## Flags

### server flags

##### Discord

- server.discord.channel.denizendebug | stores channel id
- server.discord.channel.denizendebug

### player flags

- player.status.rules_not_accepted | has not accepted the server rules

### rank

- player.rank.
#### core

- player.core.status.not_unlocked | player not unlocked for playing on the server, disables most custom functions. Main gatekeeping flag!
- player.core.afk.state | afk state of player
- player.core.afk.location | where player is afk right now
- player.core.afk.time | how long a player is afk
- player.core.afk.bypass | bypass AFK kicking
- player.core.seelenheil.amount | amount of players seelenheil (0 min and 100 max)
- player.core.fokus.amount | amount of players fokus points (mana, 0 min and 100 max)

#### skills

- player.skill.level.total | combined levels in all skills


## Notes

## Permissions

<flag_target>.<flag_category>.[<flag_subcategory/ies>].<flag_usecase/name>

targets (object where flag is stored):
- player
- server
- item
- location
- inventory
- npc

categories (based on script folders):
- core
- command
- items
- currency
- rank
- world
- chat
- claims
- skill
- quest
- npc