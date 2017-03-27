require 'mysql2'

class Speicher
  def self.init
    @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "marco", :database => "lernkarten")
  end

  def self.close
    @client.close
  end

  def self.load(obj, stapelname)
    stm = @client.prepare("SELECT a.platznr, a.frage,a.antwort, t.wissensstand FROM karte as a join stapel as b ON b.id = a.sid left join training as t ON a.id = t.knr WHERE b.name = ? ")
      res = stm.execute(stapelname)
      if res
        res.each do |karte|
         obj.neueKarte(karte['frage'],karte['antwort'], karte['platznr'], karte['wissensstand'])
        end
      end
    self.close
  end

  def self.stapel
    feld = []
    stm = @client.prepare("SELECT name FROM stapel")
    res = stm.execute
    res.each do |zeile|
      feld << zeile['name']
    end
    return feld
  end

  def self.deleteStapel(stapelname)
      stm = @client.prepare("DELETE FROM stapel WHERE name = ?")
      res = stm.execute(stapelname)
  end

  def self.deleteKarte(stapelname,id)
      stm = @client.prepare("SELECT id FROM stapel WHERE name = ?")
      res = stm.execute(stapelname)
      sid = res.first['id']
      stm = @client.prepare("DELETE FROM karte WHERE platznr = ? AND sid = ?")
      res = stm.execute(id,sid)
  end

  def self.zeigeStapelInhalt(stapelname)
    stm = @client.prepare("SELECT karte.platznr, karte.frage, karte.antwort FROM karte join stapel ON karte.sid = stapel.id WHERE stapel.name = ?")
    res = stm.execute(stapelname)

    if res.first
      puts "Inhalt des Stapels #{stapelname}: "
    end

    res.each do |data|
      puts "NR:#{data['platznr']}    F:#{data['frage']}    A:#{data['antwort']}"
    end
  end

  def self.getTrainingSessionCount
    #diese Funktion gibt den letzten Session Wert zurück
    begin
      stm = @client.prepare("SELECT session FROM training ORDER BY session DESC LIMIT 1")
      res = stm.execute
      return res.first['session'].to_i
    rescue
      return -1
    end
  end

  def self.getStats(session)
    stm = @client.prepare("SELECT karte.frage, karte.antwort, wissensstand FROM training join karte ON training.knr = karte.platznr  where session = ?")
    res = stm.execute(session)
    
    stapel = []
    anzahl_karten_pro_session = res.size
    res.each do |fragen|
        stapel << fragen
    end
    
    return stapel 
  end

  def self.aenderTraining(platznr, wissensstand, session)
    stm = @client.prepare("SELECT id FROM karte where platznr = ?")
    res = stm.execute(platznr)
    id  = res.first['id']
    stm = @client.prepare("INSERT INTO training (wissensstand, knr, session) VALUES (?,?,?)")
    res = stm.execute(wissensstand, platznr, session)
    

  end

  def self.store(obj, stapelname)
      id = false
      stm = @client.prepare("SELECT id FROM stapel where name = ?")
      res = stm.execute(stapelname)
      #Stapel existiert, dann hole die ID
      if res.first
         id = res.first['id']
      else
      #Stapel existiert nicht, dann erstelle ihn und hole ID
        @client.query("INSERT INTO stapel (name) VALUES ('#{stapelname}') ")
        res = @client.query("SELECT LAST_INSERT_ID()")
        id = res.first['LAST_INSERT_ID()']
      end
   
    obj.each do |o|
      stm = @client.prepare("SELECT count(id) as count FROM karte WHERE frage = ? AND antwort = ? AND sid = ?")
      res = stm.execute(o.getFrage, o.getAntwort, id)
      count = res.first['count'].to_i
      #Wenn der Datensatz noch nicht existiert, füge den Datensatz in die Tabelle karte ein.
      if (count > 0)
      else
        #anzahl_karten ist beschreibt den Kardinalswert aller Karten im Stapel
        anzahl_karten = @client.query("SELECT COUNT(*) as c FROM karte").first['c']
        stm = @client.prepare("INSERT INTO karte (frage, antwort, sid, platznr) VALUES (?, ? ,?, ?) ")
        res = stm.execute(o.getFrage,o.getAntwort,id,anzahl_karten)
      end
    end
     self.close
  end
end

