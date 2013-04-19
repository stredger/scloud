require "socket"
 
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
    return "text/html"
end
 
webserver = TCPServer.new('localhost', 7654)
base_dir = Dir.new(".")
while (session = webserver.accept)
  request = session.gets
  puts request
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
  resource =  trimmedrequest
  if resource == ""
    resource = "."
  end
  print resource
 
  if !File.exists?(resource)
    session.print "HTTP/1.1 404/Object Not Found\r\nSwick Server\r\n\r\n"
    session.print "404 - Resource cannot be found : #{resource} "
    session.close
    next
  end
 
  if File.directory?(resource)
    session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
    if resource == ""
      base_dir = Dir.new(".")
    else
      base_dir = Dir.new("./#{trimmedrequest}")
    end
    base_dir.entries.each do |f|
      dir_sign = ""
      base_path = resource + "/"
      base_path = "" if resource == ""
      resource_path = base_path + f
      if File.directory?(resource_path)
        dir_sign = "/"
      end
      if f == ".."
        upper_dir = base_path.split("/")[0..-2].join("/")
        session.print("<a href=\&quot;/#{upper_dir}\&quot;>#{f}/</a>")
      else
        session.print("<a href=\&quot;/#{resource_path}\&quot;>#{f}#{dir_sign}</a>")
      end
    end
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
