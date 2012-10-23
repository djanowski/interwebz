def Interwebz
  retries = 0

  begin
    yield
  rescue SocketError, EOFError, Errno::ECONNRESET
    retries += 1

    sleep(retries ** 2)

    retry if retries < 3
  end
end
