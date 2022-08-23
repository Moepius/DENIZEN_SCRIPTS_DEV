# handles all the things happening when a player is receiving or dropping currency items


# TODO: nicht freigeschaltete Spieler können Silberlinge und Co. nicht aufnehmen, selbiges für Geldbeutel
# TODO: 

# wenn ein Spieler ein Silberling Item aufnimmt
 # Testen welche Items aufgenommen wurden (Silberlinge, Kupfer, Kristalle) und deren jeweilige Anzahl

# teste ob Spieler einen Geldbeutel im Inventar hat

# wenn ja: testen ob Platz im Geldbeutel ist
    # ja: Items in den Geldbeutel, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen
    # nein: Items in das Inventar, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen, Hinweis, dass Geldbeutel voll ist

# wenn nein: Items in das Inventar, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen, Hinweis, dass Geldbeutel voll ist
# Testen ob Inventar voll ist sollte eigentlich nicht nötig sein, da die Items sonst sowieso nicht aufgenommen werden könnten


# Wenn Spieler ein Währungs Item verliert (droppt)

# Testen welche Items gedroppt wurden (Silberlinge, Kupfer, Kristalle) und deren jeweilige Anzahl
    # flag "Vermögen" oder so ähnlich um Anzahl der Items verringern