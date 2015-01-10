#
#   Author: Rohith
#   Date: 2015-01-09 21:35:26 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
require 'json'
require 'etcd'

module Vulcand
  class API
    include Logging
    include Utils

    API_KEY_VULCAN             = "/vulcand"
    API_KEY_BACKENDS           = "#{API_KEY_VULCAN}/backends"
    API_KEY_BACKEND_KEY        = "#{API_KEY_BACKENDS}/%s/backend"
    API_KEY_BACKEND_SERVERS    = "#{API_KEY_BACKENDS}/%s/servers"
    API_KEY_BACKEND_SERVER_KEY = "#{API_KEY_BACKENDS}/%s/servers/%s"
    API_KEY_FRONTENDS          = "#{API_KEY_VULCAN}/frontends"
    API_KEY_FRONENT_KEY        = "#{API_KEY_FRONTENDS}/%s/frontend"

    attr_reader :options

    def initialize(ops = {})
      @options = opts
      verbose "initializing vulcand api connection, endpoint: #{options[:host]}:#{options[:port]}"
    end

    def backends
      # step: if backends key does not exist, we create it
      set(API_KEY_BACKENDS,nil,:dir => true) unless exists?(API_KEY_BACKENDS)
      # step: get a list of backends
      get( API_KEY_BACKENDS ).node.children.map { |x| File.basename(x.key) }
    end

    def add_backend(name)
      annonce "adding the backend: #{name}"
      set(API_KEY_BACKEND_KEY % [ name ], {"Type" => "http"}.to_json)
    end

    def backend_servers(backend)
      raise ArgumentError, "the backend: #{backend} does not exists" unless backends.include? backend
      servers_key = API_KEY_BACKEND_SERVERS % [ backend ]
      get(servers_key).node.children.map { |x| File.basename(x.key) }
    end

    def add_server(service)
      annonce "adding server: #{service[:address]}:#{service[:port]} to backend: #{service[:id]}"
      # step: we first check the backend exists and if not, create it
      add_backend(service[:id]) unless backends.include? service[:id]
      # step: we add the server to the backend
      service_key = API_KEY_BACKEND_SERVER_KEY % [ service[:id], service[:name] ]
      service_data = { "URL" => "http://#{service[:address]}:#{service[:port]}" }.to_json
      set(service_key,service_data)
    end

    def remove_server(service)
      annonce "removing service: #{service[:name]} from backend: #{service[:id]}"
      # step: we make sure the backend exits
      return unless backends.include? service[:id]
      # step: remove the server
      key = API_KEY_BACKEND_SERVER_KEY % [ service[:id], service[:name] ]
      delete(key)
    end

    def add_frontend(service)
      annonce "adding a frontend: #{service[:id]}, backend: #{service[:backend]}"
      # step: we make sure the backend exists
      add_backend(service[:backend]) unless backends.include? service[:backend]
      # step: we validate and add the frontend
    end

    private
    def options
      @options ||= {}
    end

    def get(key)
      api do
        verbose "get() key: #{key}"
        etcd.get(key)
      end
    end

    def set(key,value,opts={})
      api do
        verbose "set() key: #{key}, value: #{value}, options: #{opts}"
        etcd.set(key, { :value => value }.merge(opts)) if value
        etcd.set(key, opts) unless value
      end
    end

    def delete(key)
      api do
        verbose "delete() key: #{key}"
        etcd.delete(key) if exists?(key)
      end
    end

    def exists?(key)
      api do
        verbose "exists?() key: #{key}"
        etcd.exists?(key)
      end
    end

    def api
      begin
        yield if block_given?
      rescue Exception => e
        error "failed to execute api command, error: #{e.message}"
        raise
      end
    end

    def etcd
      @etcd ||= ::Etcd::Client.new(:host => options[:host], :port => options[:port] )
    end
  end
end
