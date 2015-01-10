#
#   Author: Rohith
#   Date: 2015-01-09 21:32:13 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
module Vulcand
  module Logging
    def verbose message
      print_message(message,"v") if options[:verbose]
    end

    def annonce message
      print_message(message) if message
    end

    def error message
      print_message(message,"E")
    end

    def failed message
      print_message(message,"F")
      exit 1
    end

    private
    def print_message message, symbol = "*"
      puts "[#{timestamp}][#{symbol}]: #{message.capitalize}" if message
    end

    def timestamp
      Time.now.strftime("%d/%m/%Y %H:%M:%S")
    end
  end
end
