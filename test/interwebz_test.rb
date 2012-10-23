require "test/unit"
require "net/http"

require_relative "../lib/interwebz"

class InterwebzTest < Test::Unit::TestCase
  def test_protects_against_network_errors
    assert_raise(SocketError) do
      Net::HTTP.get_response(URI("http://localhost:98765"))
    end

    assert_nothing_raised do
      Interwebz do
        Net::HTTP.get_response(URI("http://localhost:98765"))
      end
    end
  end
end
