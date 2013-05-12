require "../song_list.rb"


# get a one line string of an array 
# (will have ref locations for objects)
def _get_one_line_array(array)
  s = "["
  array.each {|e| s += "#{e}, "}
  if s.length > 2 
    s[-2] = "]"
    s[-1] = ""
  else
    s += "]"
  end
  return s
end

def _get_one_line_song_array(songs)
  s = "["
  songs.each {|e| s += "#{e.get_info()}, "}
  if s.length > 2 
    s[-2] = "]"
    s[-1] = ""
  else
    s += "]"
  end
  return s
end


def _cmp_array(x, y)
  return -1 if x.length != y.length

  i = 0
  while i < x.length
    return -1 if x[i] != y[i]
    i += 1
  end
  return 0
end


def _get_fail_swap_elements(exp, tst)
    return "FAILED\tswap_elements(): expected #{_get_one_line_array(exp)}, got #{_get_one_line_array(tst)}"
end

def unit_test_swap_elements()
  failed = 0

  tst = [1]
  exp = [1]
  # swap the first and last (same) element in a single element array
  swap_elements(0, tst.length - 1, tst)
  if _cmp_array(tst, exp) != 0
    puts _get_fail_swap_elements(exp, tst)
    failed += 1
  end

  tst = [1, 2, 3]
  exp = [3, 2, 1]
  # swap the first and last in a 3 element array
  swap_elements(0, tst.length - 1, tst)
  if _cmp_array(tst, exp) != 0
    puts _get_fail_swap_elements(exp, tst)
    failed += 1
  end

  exp = [3, 1, 2]
  # swap the middle and last elements in a 3 element array
  swap_elements(tst.length - 2, tst.length - 1, tst)
  if _cmp_array(tst, exp) != 0
    puts _get_fail_swap_elements(exp, tst)
    failed += 1
  end

  exp = [3, 1, 2]
  # swap last with last in a 3 element array
  swap_elements(tst.length - 1, tst.length - 1, tst)
  if _cmp_array(tst, exp) != 0
    puts _get_fail_swap_elements(exp, tst)
    failed += 1
  end

  song_a = Song.new()
  song_b = Song.new()
  tst = [song_a, song_b]
  exp = [song_b, song_a]
  # swap with actual song elements
  swap_elements(0, tst.length - 1, tst)
  if _cmp_array(tst, exp) != 0
    puts _get_fail_swap_elements(exp, tst)
    failed += 1
  end

  if failed == 0
    puts "swap_elements(): passed all tests!"
  else
    puts "swap_elements(): failed #{failed} tests"
  end
end

def _get_fail_partition(type, tst, ret, exp, exp_ret)
  s = "FAILED\tpartition(): type = #{type}"
  s += "\n\texpected - (arr,pivot) (#{_get_one_line_song_array(exp)},#{exp_ret})"
  return s + "\n\tgot - (arr,pivot) (#{_get_one_line_song_array(tst)},#{ret})"
end


def _artist_partition_test()
  failed = 0
  type = "artist"

  song_a = Song.new()
  song_a.artist = "A"
  song_b = Song.new()
  song_b.artist = "B"
  song_c = Song.new()
  song_c.artist = "C"
  song_d = Song.new()
  song_d.artist = "D"
  song_e = Song.new()
  song_e.artist = "E"

  tst = [song_c, song_b, song_a]
  exp = [song_a, song_b, song_c]
  pivot = 1
  # swap with actual song elements, artist comparison
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != pivot
    puts _get_fail_partition(type, tst, ret, exp, pivot)
    failed += 1
  end

  exp = [song_a, song_b, song_c]
  pivot = 1
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != pivot
    puts _get_fail_partition(type, tst, ret, exp, pivot)
    failed += 1
  end

  tst = [song_e, song_b, song_c, song_d, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 0
  exp_ret = 4
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [song_e, song_b, song_c, song_d, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 4
  exp_ret = 0
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [song_e, song_d, song_c, song_b, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 2
  exp_ret = 2
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  return failed
end


def _album_partition_test()
  failed = 0
  type = "album"

  # with an album comparison if they are eq we go to artist
  # so we should get the same results as the first test
  song_a = Song.new()
  song_a.artist = "A"
  song_b = Song.new()
  song_b.artist = "B"
  song_c = Song.new()
  song_c.artist = "C"
  song_d = Song.new()
  song_d.artist = "D"
  song_e = Song.new()
  song_e.artist = "E"

  tst = [song_c, song_b, song_a]
  exp = [song_a, song_b, song_c]
  pivot = 1
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != pivot
    puts _get_fail_partition(type, tst, ret, exp, pivot)
    failed += 1
  end

  exp = [song_a, song_b, song_c]
  pivot = 1
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != pivot
    puts _get_fail_partition(type, tst, ret, exp, pivot)
    failed += 1
  end

  tst = [song_e, song_b, song_c, song_d, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 0
  exp_ret = 4
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [song_e, song_b, song_c, song_d, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 4
  exp_ret = 0
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [song_e, song_d, song_c, song_b, song_a]
  exp = [song_a, song_b, song_c, song_d, song_e]
  pivot = 2
  exp_ret = 2
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, nil)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  return failed
end

def _no_indir_partition_test()
  failed = 0
  # shouldn't need to check both, but im paranoid
  failed += _artist_partition_test()
  failed += _album_partition_test()
  return failed
end


def _get_fail_partition_indirection(type, tst, ret, exp, exp_ret)
  s = "FAILED\tpartition(): type = #{type}"
  s += "\n\texpected - (arr,pivot) (#{_get_one_line_array(exp)},#{exp_ret})"
  return s + "\n\tgot - (arr,pivot) (#{_get_one_line_array(tst)},#{ret})"
end

def _indirection_partition_test()
  failed = 0
  type = "artist"

  song_a = Song.new()
  song_a.artist = "A"
  song_b = Song.new()
  song_b.artist = "B"
  song_c = Song.new()
  song_c.artist = "C"
  song_d = Song.new()
  song_d.artist = "D"
  song_e = Song.new()
  song_e.artist = "E"

  ele_arr = [song_a, song_b, song_c]
  tst = [2, 1, 0] # song c, b, a
  exp = [0, 1, 2] # song a, b, c
  pivot = 1
  exp_ret = 1
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, ele_arr)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition_indirection(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  exp = [0, 1, 2] # song a, b, c
  pivot = 0
  exp_ret = 0
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, ele_arr)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition_indirection(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  ele_arr = [song_a, song_b, song_c, song_d, song_e]
  tst = [4, 1, 2, 3, 0] # e, b, c, d, a
  exp = [0, 1, 2, 3, 4] # a, b, c, d, e
  pivot = 0
  exp_ret = 4
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, ele_arr)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [4, 1, 2, 3, 0]
  exp = [0, 1, 2, 3, 4]
  pivot = 4
  exp_ret = 0
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, ele_arr)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  tst = [4, 3, 2, 1, 0] # e, d, c, b, a
  exp = [0, 1, 2, 3, 4] # a, b, c, d, e
  pivot = 2
  exp_ret = 2
  # swap with actual song elements
  ret = partition(tst, 0, tst.length - 1, pivot, type, ele_arr)
  if _cmp_array(tst, exp) != 0 or ret != exp_ret
    puts _get_fail_partition(type, tst, ret, exp, exp_ret)
    failed += 1
  end

  return failed
end


def unit_test_partition()
  failed = 0
  failed += _no_indir_partition_test()
  failed += _indirection_partition_test()
  
  if failed == 0
    puts "partition(): passed all tests!"
  else
    puts "partition(): failed #{failed} tests"
  end
end


def unit_test_quicksort()
  failed = 0

  if failed == 0
    puts "quicksort(): passed all tests!"
  else
    puts "quicksort(): failed #{failed} tests"
  end
end


def all_unit_tests()
  unit_test_swap_elements()
  unit_test_partition()
end

all_unit_tests()
