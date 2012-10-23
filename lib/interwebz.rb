def Interwebz
  begin
    yield
  rescue SocketError
  end
end
