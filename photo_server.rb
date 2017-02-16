class PhotoServer
  def initialize
    @server = SimpleHttpServer.new({
      :server_ip => "0.0.0.0",
      :port  =>  8000,
      :document_root => File.join(File.dirname(__FILE__), "image"),
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
  <img src="0.jpg" width="128" height="128">
  <img src="1.jpg" width="128" height="128">
  <img src="3.jpg" width="128" height="128">
  <img src="4.jpg" width="128" height="128">
  <img src="5.jpg" width="128" height="128">
</body>
</html>
EOS

    @server.create_response
  end

  def run
    puts @server.url
    @server.run
  end
end

PhotoServer.new.run
