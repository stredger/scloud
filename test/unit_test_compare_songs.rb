
require "../song_list.rb"

# NOTE: requires song tests to pass


def _get_test_fail_message(song_a, song_b, type, exp, got)
  s = "FAILED\tcompare_songs(): #{type} comparison: expected #{exp} got #{got}"
  s += "\n\t- #{song_a.get_info()}\n\t- #{song_b.get_info()}"
  return s
end


def _test_artist_type()

  failed = 0
  song_a = Song.new()
  song_b = Song.new()

  song_a.artist = "Aaaaaa"
  song_b.artist = "Aaaaab"
  cmp = 0
  # artist a <=> b. a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", -1, cmp)
  end

  cmp = 0
  # artist b <=> a, b is greater than a so expect 1
  cmp = compare_songs(song_b, song_a, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "artist", 1, cmp)
  end

  song_a.artist = song_b.artist
  song_a.album = "Aaaa Bbbb"
  song_b.album = "Aaaa Bbbc"
  cmp = 0
  # artist a = b. So do album a <=> b, a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", -1, cmp)
  end

  cmp = 0
  # artist a = b. So do album b <=> a, b is greater than a so expect 1
  cmp = compare_songs(song_b, song_a, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "artist", 1, cmp)
  end

  song_a.album = song_b.album
  song_b.track_num = "1"
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect -1 as a < b
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", -1, cmp)
  end

  cmp = 0
  # artist a = b and album a = b, So test track_num b <=> a
  # expect 1 as b > a
  cmp = compare_songs(song_b, song_a, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "artist", 1, cmp)
  end

  song_a.track_num = song_b.track_num
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect 1 as a and b are equal
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", 1, cmp)
  end

  song_a.track_num = "11"
  song_b.track_num = "2"
  # artist a = b and album a = b, So test track_num a <=> b 
  # expect 1 as a is greater
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", 1, cmp)
  end

  return failed
end


def _test_album_type()

  failed = 0
  song_a = Song.new()
  song_b = Song.new()

  song_a.album = "Aaaaaa"
  song_b.album = "Aaaaab"
  cmp = 0
  # album a <=> b. a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "album", -1, cmp)
  end

  cmp = 0
  # album b <=> a. b is greater than a so expect 1
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "album", 1, cmp)
  end

  song_a.album = song_b.album
  song_a.artist = "A"
  song_b.artist = "Ab"
  cmp = 0
  # album a = b. Now artist a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "album", -1, cmp)
  end

  cmp = 0
  # album a = b. Now artist b is greater than a so expect 1
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "album", 1, cmp)
  end

  song_a.artist = song_b.artist
  song_b.track_num = "2"
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect -1 as a < b
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "album", -1, cmp)
  end

  cmp = 0
  # artist a = b and album a = b, So test track_num b <=> a
  # expect 1 as b > a
  cmp = compare_songs(song_b, song_a, "album")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "album", 1, cmp)
  end

  song_a.track_num = song_b.track_num
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect 1 as a and b are equal
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "album", 1, cmp)
  end

  song_a.track_num = "11"
  song_b.track_num = "2"
  # artist a = b and album a = b, So test track_num a <=> b 
  # expect 1 as a is greater
  cmp = compare_songs(song_a, song_b, "album")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "album", 1, cmp)
  end

  return failed
end


def _test_genre_type()

  failed = 0
  song_a = Song.new()
  song_b = Song.new()


  song_a.genre = "Electro"
  song_b.genre = "Electronic"
  cmp = 0
  # genre a <=> b. a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", -1, cmp)
  end

  cmp = 0
  # genre a <=> b. b is greater than a so expect 1
  cmp = compare_songs(song_b, song_a, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "genre", 1, cmp)
  end

  song_a.genre = song_b.genre
  song_a.artist = "Aaaaaa"
  song_b.artist = "Aaaaab"
  cmp = 0
  # artist a <=> b. a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", -1, cmp)
  end

  cmp = 0
  # artist b <=> a, b is greater than a so expect 1
  cmp = compare_songs(song_b, song_a, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "genre", 1, cmp)
  end

  song_a.artist = song_b.artist
  song_a.album = "Aaaa Bbbb"
  song_b.album = "Aaaa Bbbc"
  cmp = 0
  # artist a = b. So do album a <=> b, a is less than b so expect -1
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", -1, cmp)
  end

  cmp = 0
  # artist a = b. So do album b <=> a, b is greater than a so expect 1
  cmp = compare_songs(song_b, song_a, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "genre", 1, cmp)
  end

  song_a.album = song_b.album
  song_b.track_num = "1"
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect -1 as a < b
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", -1, cmp)
  end

  cmp = 0
  # artist a = b and album a = b, So test track_num b <=> a
  # expect 1 as b > a
  cmp = compare_songs(song_b, song_a, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_b, song_a, "genre", 1, cmp)
  end

  song_a.track_num = song_b.track_num
  cmp = 0
  # artist a = b and album a = b, So test track_num a <=> b
  # expect 1 as a and b are equal
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", 1, cmp)
  end

  song_a.track_num = "11"
  song_b.track_num = "2"
  # artist a = b and album a = b, So test track_num a <=> b 
  # expect 1 as a is greater
  cmp = compare_songs(song_a, song_b, "genre")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "genre", 1, cmp)
  end

  return failed
end

# these might be better to test partition with
def _general_comp_tests()
  failed = 0

  song_a = Song.new()
  song_a.artist = "Oach And The Butts"
  song_a.album = "Butts Forever"
  song_a.genre = "Stank"
  song_a.track_num = "3"

  song_b = Song.new()
  song_b.artist = "Mad Kyle"
  song_b.album = "Butts Forever"
  song_b.genre = "Kyle"
  song_b.track_num = "1"

  song_c = Song.new()
  song_c.artist = "Mad Kyle"
  song_c.album = "Butts Forever"
  song_c.genre = "Stank"
  song_c.track_num = "2"

  cmp = 0
  # artist comparison, O comes after M, so expect 1 (a is larger)
  cmp = compare_songs(song_a, song_b, "artist")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_b, "artist", 1, cmp)
  end

  cmp = 0
  # album comparison, same artist and album, but b has lower track num
  # so expect -1 (b is smaller)
  cmp = compare_songs(song_b, song_c, "album")
  if cmp != -1
    failed += 1
    puts _get_test_fail_message(song_b, song_c, "album", -1, cmp)
  end

  cmp = 0
  # album comparison, same album, but c has lower artist (M < O)
  # so expect 1 (a is larger)
  cmp = compare_songs(song_a, song_c, "album")
  if cmp != 1
    failed += 1
    puts _get_test_fail_message(song_a, song_c, "album", 1, cmp)
  end

  return failed
end


def unit_test_compare_songs()
  failed = 0

  failed += _test_artist_type()
  failed += _test_album_type()
  failed += _test_genre_type()
  failed += _general_comp_tests()

  if failed == 0
    puts "compare_songs(): passed all tests!"
  else
    puts "compare_songs(): failed #{failed} tests"
  end
end


unit_test_compare_songs()
