require "socket"

Thread.abort_on_exception = true

servers = []

servers << Thread.new do
  # This server never works.

  server = TCPServer.new(3333)

  server.accept.close
end

servers << Thread.new do
  # This server works on the 3rd retry.

  server = TCPServer.new(3334)

  count = 0

  loop do
    client = server.accept

    if count < 2
      client.close
    else
      until client.gets == "\r\n"; end

      client.puts("HTTP/1.1 200 OK\nContent-Length: 5\n\nw00t!")
      client.close
    end

    count += 1
  end
end

servers.each(&:join)
