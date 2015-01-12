#
#   Author: Rohith
#   Date: 2015-01-09 21:33:38 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
gem 'docker-api', :require => 'docker'
require 'docker'

module Vulcand
  module Docker
    class << self
      def get(id)
        ::Docker::Container.get(id)
      end

      def containers
        ::Docker::Container.all.each do |container|
          yield container.id if block_given?
        end
      end

      def hostname(container)
        container.info['Config']['Hostname']
      end

      def environment(container)
        (container.info['Config']['Env'] || {}).inject({}) do |h, item|
          h[$1] = $2 if item =~ /(.*)=(.*)/
          h
        end
      end

      def set_socket(filename)
        ::Docker.url = "unix://#{filename}"
      end

      def ports(container)
        ports = {}
        (container.info['NetworkSettings']['Ports'] || {}).each_pair do |port, value|
          # check: the container can expose port, which are not mapped or used .. leaving us with
          # {"443/tcp"=>nil, "80/tcp"=>[{"HostIp"=>"0.0.0.0", "HostPort"=>"31002"}]}
          next unless value
          # else extract the port
          ports[$1] = value.first['HostPort'] if port =~ /^([0-9]{1,5})\/tcp$/
        end
        ports
      end

      def ipaddress(container)
        container.info['NetworkSettings']['IPAddress'] || nil
      end

      def cid(container_id)
        container_id[0..13] if container_id
      end

      def events
        ::Docker::Event.stream do |event|
          yield event.id, event.status if block_given?
        end
      end
    end
  end
end
