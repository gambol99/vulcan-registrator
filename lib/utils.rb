#
#   Author: Rohith
#   Date: 2015-01-09 21:32:20 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
module Vulcand
  module Utils
    class << self
      def validate_socket filename
        raise ArgumentError, "the file: #{filename} does not exist" unless File.exist? filename
        raise ArgumentError, "the file: #{filename} is not a socket" unless File.socket? filename
        raise ArgumentError, "the socket: #{filename} is not readable" unless File.readable? filename
        raise ArgumentError, "the socket: #{filename} is not writable" unless File.writable? filename
        filename
      end

      def validate_ipaddress address
        raise ArgumentError, "you have not specfied an ip address to register services" unless address
        raise ArgumentError, "the ip address: #{address} is invalid" unless address =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
        address
      end
    end
  end
end
