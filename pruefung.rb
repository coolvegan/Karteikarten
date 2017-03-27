require 'io/console'


class Prüfung
  def initialize(stapel)
    @karten = stapel.getObj
  end

  def stats(session)
    system("clear")
    Speicher.init
    feld = Speicher.getStats(session)

    #
    #
    #ermitteln wieviel antworten richtig waren
    gewusst = 0
    anzahlk = feld.size
    fail = []
    feld.each do |f|
      if f['wissensstand'] == 1
        gewusst+=1
      else
        fail << f
      end
    end
    
    puts "Du hast #{gewusst} von #{anzahlk} Fragen richtig beantwortet."
    puts "Deine Erfolgsquote liegt bei #{((gewusst.to_f/anzahlk).to_f*100).round(2)}%."

    if fail.size > 0
      STDIN.getch
      system("clear")
      puts "Hier eine Liste der Fragen die du nicht wusstest.\n\n"
      fail.each do |f|
        puts "Frage: #{f['frage']}"
        puts "Antwort: #{f['antwort']}\n\n"
      end
    end
  end


  def start


    #session auslesen
      Speicher.init
      session = Speicher.getTrainingSessionCount+1
    
      @karten.shuffle.each_with_index do |testaufgabe,i|
      #console leeren  
      system("clear")
      puts "[Frage #{i+1}: #{testaufgabe.getFrage}]\n\n\n"
      puts "[A]ntwort - [G]ewusst - [N]icht-Gewusst"
      #tastaturabfrage
      antwort = STDIN.getch
      case antwort.downcase
      when 'g'
        Speicher.init
        Speicher.aenderTraining(testaufgabe.getPlatznr,1,session)
        next
      when 'a'
        system("clear")
        puts "[Antwort #{i+1}: #{testaufgabe.getAntwort}]\n\n\n\n"
        puts "Taste für weiter..."
        STDIN.getch 
        redo 
      when 'n'
        Speicher.init
        Speicher.aenderTraining(testaufgabe.getPlatznr,0,session)
      else
        redo
      end
    end
      self.stats(session)
  end

end
