require 'simplehttpserver'

def document_root
  File.dirname(__FILE__)
end

class PhotoServer
  def initialize(paths)
    @server = SimpleHttpServer.new({
      :server_ip => "0.0.0.0",
      :port => 8000,
      :document_root => document_root,
    })

    @server.http do |r|
      @server.set_response_headers({
        "Server" => "photo_server",
        "Date" => @server.http_date,
      })
    end

    @server.location "/" do |r|
      @server.set_response_headers "Content-type" => "text/html; charset=utf-8"

      @server.response_body = <<EOS
<html>
<head>
  <title>Photo Server</title>
</head>
<body>
  <h1>Photo Server</h1>
  #{paths.map { |e| "<img src=\"#{e}\" width=\"256\">" }.join("\n")}
</body>
</html>
EOS

      @server.create_response
    end

    @server.location "/image" do |r|
      path = File.join @server.config[:document_root], r.path
      # p path
      # p File.size path
      @server.file_response r, path, "image/jpeg"
    end
  end

  def run
    puts @server.url
    @server.run
  end
end

#---
imgs = Image.pick_from_library(50)
paths = []

image_dir = File.join(document_root, "image")
Dir.mkdir image_dir unless Dir.exist? image_dir
Dir.foreach(image_dir) do |e|
  path = File.join(image_dir, e)
  File.delete(path) if File.file?(path)
end

imgs.each_with_index do |img, no|
  img = img.resize(640, img.h)
  filename = File.join(image_dir, "#{no}.jpg")
  img.save_to(filename)
  paths << filename
  puts filename
end

PhotoServer.new(paths).run

