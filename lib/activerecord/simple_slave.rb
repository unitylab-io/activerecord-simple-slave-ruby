module ActiveRecord
  module SimpleSlave
    def slave_connection_spec
      return @slave_spec unless @slave_spec.nil?

      resolver = \
        ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.new(
          'slave' => connection_config.stringify_keys
        )
      @slave_spec = resolver.spec(:slave).tap do |sp|
        address = ENV.fetch('DATABASE_SIMPLE_SLAVE', sp.config[:simple_slave])
        next if address.nil?

        host, port = address.split(':')
        sp.config[:host] = host
        sp.config[:port] = port unless port.nil?
      end
    end

    def slave_connection_pool
      @slave_connection_pool ||= \
        ActiveRecord::ConnectionAdapters::ConnectionPool.new(
          slave_connection_spec
        )
    end

    def with_slave(&_block)
      retvalue = nil
      slave_connection_pool.with_connection do |connection|
        Thread.current[:selected_connection] = connection
        retvalue = yield(connection)
        Thread.current[:selected_connection] = nil
      end
      retvalue
    end

    def connection
      if !Thread.current[:selected_connection].nil?
        Thread.current[:selected_connection]
      else
        super
      end
    end
  end
end
