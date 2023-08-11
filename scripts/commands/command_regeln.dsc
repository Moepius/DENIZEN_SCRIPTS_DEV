command_regeln:
    type: command
    debug: false
    name: regeln
    description: Craftasy Regelwerk
    usage: /regeln
    aliases:
    - rules
    - rule
    - regel
    - gesetz
    script:
    - playsound <player> sound:ui_toast_in volume:1 pitch:1
    - adjust <player> show_book:craftasy_rules


craftasy_rules:
    type: book
    title: Craftasy Regeln
    author: Craftasy
    signed: true
    text:
    - <&6>1.<&0> Die Bau- und Spielregeln für die jeweiligen Spielwelten sind zu befolgen.<n><n><&6>2.<&0> Hilfe gibt's über unser Hilfe-Menü bzw. mit dem Befehl /support. Um persönlichen Zwist kümmern wir uns nicht.
    - <&6>3.<&0> Wir legen großen Wert auf qualitativ hochwertige Bauwerke und Konzepte, jeder soll dazu beitragen.<n><n><&6>4.<&0> Wer nervt, wird gebannt. Wir wollen hier mit Leuten spielen, die sich zu benehmen wissen und respektvoll miteinander umgehen.
    - <&6>5.<&0> Gemoddete Clienten sind erlaubt, sofern sie keinen unfairen Vorteil schaffen (X-Ray, Flying Hacks, etc.).<n><n><&6>6.<&0> Gesunder Menschenverstand wird vorausgesetzt: kein Trolling, kein illegaler Stuff, oder stark offensive Sprache.