$servers = spawn("ruby #{File.expand_path("servers.rb", File.dirname(__FILE__))}")

at_exit do
  Process.kill(:QUIT, $servers)
  Process.waitpid($servers)
end

require "test/unit"
require "net/http"

require_relative "../lib/interwebz"

class InterwebzTest < Test::Unit::TestCase
  def test_protects_against_network_errors
    assert_raise(SocketError) do
      Net::HTTP.get_response(URI("http://localhost:98765"))
    end

    assert_nothing_raised do
      Interwebz(throttle: 0, retries: 2) do
        Net::HTTP.get_response(URI("http://localhost:98765"))
      end
    end
  end

  def test_retries_a_few_times
    sleep(0.5)

    assert_raise(Errno::ECONNRESET, EOFError) do
      Net::HTTP.get_response(URI("http://localhost:3333"))
    end

    response = nil

    assert_nothing_raised do
      Interwebz(throttle: 0) do
        response = Net::HTTP.get_response(URI("http://localhost:3334")).body
      end
    end

    assert_equal "w00t!", response
  end
end
