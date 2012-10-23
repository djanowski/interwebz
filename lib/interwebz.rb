def Interwebz(options = {})
  throttle = options.fetch(:throttle, 1)
  maximum_retries = options.fetch(:retries, nil)
  retries = 0

  begin
    yield

    retries = 0
  rescue SocketError, \
         EOFError, \
         Errno::ECONNREFUSED, \
         Errno::ECONNRESET, \
         Errno::EHOSTUNREACH, \
         Errno::ENETUNREACH, \
         Errno::ETIMEDOUT

    retries += 1

    sleep([retries ** 2 * throttle, 300].min)

    retry if maximum_retries.nil? || retries < maximum_retries
  end
end
