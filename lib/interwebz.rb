def Interwebz(options = {})
  throttle = options.fetch(:throttle, 1)
  retries = 0

  begin
    yield
  rescue SocketError, EOFError, Errno::ECONNRESET
    retries += 1

    sleep(retries ** 2 * throttle)

    retry if retries < 3
  end
end
