# -*- coding: utf-8 -*-


# Song class
class Song
  @@local_root = "/iTunes/"
  @@server_root = "http://10.0.1.8:8000/"
  attr_accessor :title, :artist, :album, :time, :genre, :track_num, :location

  # default values, title and location are required so leave nil
  def initialize()
    @artist = ""
    @album = ""
    @time = "0"
    @genre = ""
    @track_num = "0"
  end


  def set_local_root(path)
    @@local_root = path unless path.nil?
  end

  def set_server_root(path)
    @@server_root = path unless path.nil?
  end

  def format_location_path()
    chopped = @location.split(@@local_root, 2)
    if chopped.length == 2
      @location = @@server_root + chopped[-1] 
    end
  end

  def add_attr(attr)
    return if attr.nil?

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
    when "Track Number"
      @track_num = attr[1]
    when "Location"
      @location = attr[1]
    else
      nil
    end
  end

  def is_valid?()
    return !(@title.nil? or @location.nil?)
  end

  def get_info()
    return "#{@artist}:#{@album}:#{@track_num}:#{@genre}"
  end

  def print()
    puts "Title:\t" + @title
    puts "Artist:\t" + @artist
    puts "Album:\t" + @album
    puts "Time:\t" + @time
    puts "Genre:\t" + @genre
    puts "Track Num:\t" + @track_num
    puts "Location:\t" + @location
  end

  def to_json()
    return "{\"title\":\"#{escape_for_json(@title)}\", \"artist\":\"#{escape_for_json(@artist)}\", \"album\":\"#{escape_for_json(@album)}\", \"time\":#{escape_for_json(@time)}, \"genre\":\"#{escape_for_json(@genre)}\", \"track_num\":#{escape_for_json(@track_num)}, \"location\":\"#{escape_for_json(@location)}\"}"
  end

end


# Functions

def escape_for_json(str)
  # cant figure out how to esacpe \\ properly in ruby (\\\\ doesn't work), so just use the html code &#92
  escape_seqs = [ ["\\","&#92"], ["/","\\/"], ["\"","\\\""], ["\n","\\n"], ["\r","\\r"], ["\t","\\t"], ["\x08","\\f"], ["\x0c","\\b"] ]
  escape_seqs.each { |seq| str = str.gsub(seq[0], seq[1]) }
  return str
end


def parse_line(line)
  vals = line.partition('><')
  if vals.length > 2
    unless (m = vals[0].match(/>.*</)).nil?
      ele = m[0].sub('>', '').sub('<', '')
      unless ( (m = vals[2].match(/>.*</)).nil? or ele.nil? )
        attr = m[0].sub('>', '').sub('<', '')
        return [ele, attr] unless attr.nil?
      end
    end
  end
  return nil
end


def song_list_from_xml(xml_file)
  song_indicator = "<key>Track ID</key>"
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
      if song.is_valid?
        song.format_location_path
        song_list << song
      end
    else
      i += 1
    end
  end
  return song_list
end


def compare_songs(song_a, song_b, type)

  case type
  when "artist"
    cmp = song_a.artist <=> song_b.artist
    return cmp unless cmp == 0
    cmp = song_a.album <=> song_b.album
    return cmp unless cmp == 0
    return -1 if Integer(song_a.track_num) < Integer(song_b.track_num)
    return 1
  when "album"
    cmp = song_a.album <=> song_b.album
    return cmp unless cmp == 0
    cmp = song_a.artist <=> song_b.artist
    return cmp unless cmp == 0
    return -1 if Integer(song_a.track_num) < Integer(song_b.track_num)
    return 1
  when "genre"
    cmp = song_a.genre <=> song_b.genre
    return cmp unless cmp == 0
    cmp = song_a.artist <=> song_b.artist
    return cmp unless cmp == 0
    cmp = song_a.album <=> song_b.album
    return cmp unless cmp == 0
    return -1 if Integer(song_a.track_num) < Integer(song_b.track_num)
    return 1
  else
    puts "compare_songs(): unrecognized type -> #{type}"
  end
end

def swap_elements(i, j, array)
  tmp = array[i]
  array[i] = array[j]
  array[j] = tmp
end

def partition(array, left, right, pivot, type, ele_array)
  ele_array.nil? ? indir = false : indir = true

  if indir == true
    pivot_ele = ele_array[array[pivot]]
  else
    pivot_ele = array[pivot]
  end
  swap_elements(pivot, right, array)
  store_ind = left

  i = left
  while i < right
    if indir == true
      cmp = compare_songs(ele_array[array[i]], pivot_ele, type)
    else
      cmp = compare_songs(array[i], pivot_ele, type)
    end
    if cmp == -1 # -1 means less than from compare songs
      if i != store_ind
        swap_elements(i, store_ind, array)
      end
      store_ind += 1
    end
    i += 1
  end

  if store_ind != right
    swap_elements(store_ind, right, array)
  end

  return store_ind
end

def quicksort(array, left, right, type, ele_array)

  return if (right - left) < 1
  pivot = ((right - left) / 2) + left
  pivot = partition(array, left, right, pivot, type, ele_array)

  quicksort(array, left, pivot - 1, type, ele_array)
  quicksort(array, pivot + 1, right, type, ele_array)
end


def print_array(arr)
  s = ""
  arr.each {|a| s << "#{a}," }
  s[-1] = ""
  puts s
end


def create_song_list(music_lib)

  songs = song_list_from_xml(music_lib)
  quicksort(songs, 0, songs.length - 1, "artist", nil)
  return songs
end


def create_sorting_list(songs, type)
  new_arr = (0..(songs.length - 1)).to_a
  quicksort(new_arr, 0, new_arr.length-1, type, songs)
  return new_arr
end


def create_all_song_lists(music_lib)
  songs = create_song_list(music_lib)
  album_list = create_sorting_list(songs, "album")
  genre_list = create_sorting_list(songs, "genre")
  return [songs, album_list, genre_list]
end


def all_lists_to_json(lists)
  songs = lists[0]
  album_list = lists[1]
  genre_list = lists[2]

  json = "{\"songs\":["
  songs.each() { |s| json += s.to_json() + "," }
  json[-1] = "]"

  json += ",\"album_list\":["
  album_list.each() { |n| json += "#{n},"}
  json[-1] = "]"

  json += ",\"genre_list\":["
  genre_list.each() { |n| json += "#{n},"}
  json[-1] = "]"
  json += "}"

  return json
end


def get_song_lists(music_lib)
  lists = create_all_song_lists(music_lib)
  return all_lists_to_json(lists)
end


def test
  #music_lib = "test/test.xml"
  music_lib = "test/test2.xml"
  #music_lib = "test/test3.xml"

  #music_lib = "/Users/stredger/Music/iTunes/iTunes Music Library.xml"

  #require 'benchmark'
  


  # songs = create_song_list(music_lib)
  # puts "------ARTIST------"
  # for s in songs
  #   puts "#{s.artist} : #{s.album} : #{s.track_num} : #{s.genre}"
  # end
  # album_search_list = create_sorting_list(songs, "album")
  # puts "\n------ALBUM------"
  # for s in album_search_list
  #   puts "#{songs[s].artist} : #{songs[s].album} : #{songs[s].track_num} : #{songs[s].genre}"
  # end
  # puts "\n------GENRE------"
  # genre_search_list = create_sorting_list(songs, "genre")
  # for s in genre_search_list
  #   puts "#{songs[s].artist} : #{songs[s].album} : #{songs[s].track_num} : #{songs[s].genre}"
  # end

  lists = create_all_song_lists(music_lib)
  all_lists_to_json(lists)

end

#arr = [6,5,4,3,2,1,0]
# arr = [6,4,1,2,2,7,3,1,2,5,3,7,3,7,8,3,7,4,5,4,3,7,5,2,5,6,3,5,8,3]

# puts "arr:"
# print_array(arr)
# puts "\nsorted:"
# quicksort(arr, 0, arr.length-1, "")
# print_array(arr)
