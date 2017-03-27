class Karte
  #Ruby unterstützt kein Konstruktor-Überladen 
  def initialize(*args)
    case args.size
    when 2
      self.neueFrageAntwort(args[0],args[1])
    when 4
      self.neueFAPW(args[0], args[1], args[2], args[3])
    end
  end

  def neueFrageAntwort(frage,antwort)
    @frage = frage
    @antwort = antwort
  end

  def neueFAPW(frage, antwort, platznr, wissensstand)
    #neueFrageAntwortPlatznrWissensstand
    @frage = frage
    @antwort = antwort
    @platznr = platznr
    @wissensstand = wissensstand
  end

  def getFrage
    return @frage
  end
  def getAntwort
    return @antwort
  end

  def getPlatznr
    return @platznr
  end

  def getWissensstand
    return @wissensstand
  end
end
