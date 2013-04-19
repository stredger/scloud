require "socket"
require "libparse.rb"
require "Thread"
 

webserver = TCPServer.new('localhost', 7654)
base_dir = Dir.pwd << "/"
music_lib_dir = "test/"
music_lib_file = "test.xml" #"iTunes Music Library.xml"

def get_content_type(path)
  ext = File.extname(path)
  return "text/html"  if ext == ".html" or ext == ".htm"
  return "text/plain" if ext == ".txt"
  return "text/css"   if ext == ".css"
  return "image/jpeg" if ext == ".jpeg" or ext == ".jpg"
  return "image/gif"  if ext == ".gif"
  return "image/bmp"  if ext == ".bmp"
  return "text/plain" if ext == ".rb"
  return "text/xml"   if ext == ".xml"
  return "text/xml"   if ext == ".xsl"
  return "text/javascript" if ext == ".js"
  return "audio/mpeg" if ext == ".mp3" or ext == ".m4a"
  return "text/html"
end


while (session = webserver.accept)
  request = session.gets
  puts request
  next if request.nil?
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
  resource = trimmedrequest

  if resource == ""
    resource = "main.htm"
  elsif resource == "Song/List"
    songs = song_list_from_xml(music_lib_file)
    reply = "["
    for s in songs
      reply << s + ","
    end
    reply[-1] = "]"
    session.print "HTTP/1.1 200/OK\r\nServer: Swick\r\nContent-type: application/json\r\n\r\n"
    session.print reply
    session.close
    next
  #elsif resource.include?("Song/")
    #resource = resource.sub("Song/", music_lib_dir)
  else
    resource = base_dir + resource
  end

  puts resource

  if !File.exists?(resource)
    puts "404 #{resource}"
    session.print "HTTP/1.1 404/Object Not Found\r\nSwick Server\r\n\r\n"
    session.print "404 - Resource cannot be found : #{resource} "
    session.close
    next
  else
    contentType = get_content_type(resource)
    session.print "HTTP/1.1 200/OK\r\nServer: Swick\r\nContent-type: #{contentType}\r\n\r\n"
    File.open(resource, "rb") do |f|
      while (!f.eof?) do
        buffer = f.read(256)
        session.write(buffer)
      end
    end
  end
  session.close
end
