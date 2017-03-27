#!/bin/ruby
require_relative './speicher.rb'
require_relative './stapel.rb'
require_relative './karte.rb'
require_relative './pruefung.rb'

stapel = nil
frage = nil
antwort = nil
id = nil
z = false

if ARGV.empty?
  puts "./main -s <stapelname> - Karteikarten in Stapel anzeigen."
  puts "./main -z - Stapel anzeigen."
  puts "./main -dS <stapelname> - Stapel löschen."
  puts "-s    Stapelname"
  puts "-f    Frage"
  puts "-a    Antwort"
  puts "-d    Löschen"
end

ARGV.each_with_index do |a,i|

  if a == "-s"
    if !ARGV[i+1].to_s.match(/-/)
      stapel = ARGV[i+1]
    end
  end

  if a == "-d"
    if !ARGV[i+1].to_s.match(/-/)
      id = ARGV[i+1]
    end
  end

  if a == "-f"
    if !ARGV[i+1].to_s.match(/-/)
      frage = ARGV[i+1]
    end
  end
  
  if a == "-a"
    if !ARGV[i+1].to_s.match(/-/)
      antwort = ARGV[i+1]
    end
  end
  
  if a == "-z"
    if !ARGV[i+1].to_s.match(/-/)
      z = true
      Speicher.init
      daten = Speicher.stapel

      if daten.size > 0
        puts "Stapelübersicht:"
        daten.each_with_index do |x,i|
        puts "#{i+1}: #{x}"
      end
      end

      break
    end
  end


  if a == "-exam"
    if !ARGV[i+1].to_s.match(/-/)
      pfragen = ARGV[i+1]
      pruefung = Stapel.new(pfragen)

      Speicher.init
      Speicher.load(pruefung, pfragen)

      p = Prüfung.new(pruefung)
      p.start
    end
  end

  if a == "-dS"
    if !ARGV[i+1].to_s.match(/-/)
      stapelname = ARGV[i+1] 
      Speicher.init
      Speicher.deleteStapel(stapelname)
    end
  end
end


if stapel && !id && !frage && !antwort
  Speicher.init
  Speicher.zeigeStapelInhalt(stapel)
end

if stapel && id && !frage && !antwort 
  Speicher.init
  Speicher.deleteKarte(stapel,id)
end


if stapel && frage && antwort
  s = Stapel.new(stapel)
  s.neueFrageAntwort(frage,antwort)
  Speicher.init
  Speicher.store(s.getObj, stapel)
end

