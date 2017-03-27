class Stapel
  def initialize(name)
    @name = name
    @karten = []
  end

  def getStapelname
    return @name
  end

  def neueFrageAntwort(frage,antwort)
    karte = Karte.new(frage, antwort)
    @karten << karte
  end

  def neueKarte(frage,antwort, platznr, wissensstand)
    karte = Karte.new(frage,antwort,platznr,wissensstand)
    @karten << karte
  end
  
  def zeigStapel
    @karten.each do |k|
      puts "#{k.getFrage} #{k.getAntwort}"
    end
  end

  def getObj
    return @karten
  end
  
end
