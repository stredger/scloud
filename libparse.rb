

# Song class
class Song
  @@local_root = "/iTunes/"
  @@server_root = "http://localhost:8000/"
  def initialize()
    @title = nil
    @artist = nil
    @album = nil
    @time = nil
    @genre = nil
    @location = nil
  end

  def set_local_root(path)
    @@local_root = path unless path.nil?
  end

  def set_server_root(path)
    @@server_root = path unless path.nil?
  end

  def format_location_path
    chopped = @location.split(@@local_root, 2)
    if chopped.length == 2
      @location = @@server_root + chopped[-1] 
    end
  end

  def add_attr(attr)
    case attr[0]
    when "Name"
      @title = attr[1]
    when "Artist"
      @artist = attr[1]
    when "Album"
      @album = attr[1]
    when "Total Time"
      @time = attr[1]
    when "Genre"
      @genre = attr[1]
    when "Location"
      # parse attr[1]
      @location = attr[1]
    else
      nil
    end
  end

  def is_valid?
    return !(@title.nil? or @location.nil?)
  end

  def print
    puts "Title:\t" + @title
    puts "Artist:\t" + @artist
    puts "Album:\t" + @album
    puts "Time:\t" + @time
    puts "Genre:\t" + @genre
    puts "Location:\t" + @location
  end

  def to_json
    return "{\"title\":\"#{@title}\", \"artist\":\"#{@artist}\", \"album\":\"#{@album}\", \"time\":#{@time}, \"genre\":\"#{@genre}\", \"location\":\"#{@location}\"}"
  end

end


# Functions

def parse_line(line)
  vals = line.partition('><')
  ele = vals[0].match(/>.*</)[0].sub('>', '').sub('<', '')
  attr = vals[2].match(/>.*</)[0].sub('>', '').sub('<', '')
  return [ele, attr]
end


def song_list_from_xml(xml_file)
  song_indicator = "<key>Name</key>"
  song_terminator = "</dict>"

  xml = File.readlines(xml_file)
  song_list = []

  i = 0
  while i < xml.length
    if xml[i].include?(song_indicator)
      song = Song.new()
      while !( xml[i].include?(song_terminator) )
        line = parse_line(xml[i])
        song.add_attr(line)
        i += 1
      end

      puts song.format_location_path
      song_list << song.to_json if song.is_valid?
    else
      i += 1
    end
  end
  return song_list
end


def test
  music_lib = "test/test.xml" #"iTunes Music Library.xml"

  songs = song_list_from_xml(music_lib)

  for s in songs
    puts "--Song--"
    puts s
    puts "\n"
  end
end


test
