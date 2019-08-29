module ActiveRecord
  module SimpleSlave
    def simple_slave_url
      ENV.fetch(
        'DATABASE_SIMPLE_SLAVE_URL', connection_config[:simple_slave_url]
      )
    end

    def simple_slave_configuration
      @simple_slave_configuration ||= connection_config.dup.tap do |config|
        if simple_slave_url.nil?
          if defined?(::Rails)
            ::Rails.logger.warn \
              'simple slave disabled (no configuration provided)'
          end
          next
        end

        uri = URI.parse(simple_slave_url)
        config[:host] = uri.host
        config[:port] = uri.port unless uri.port.nil?
        config[:username] = uri.user unless uri.user.nil?
        config[:password] = uri.password unless uri.password.nil?
        if !uri.path.nil? && uri.path.length > 1
          config[:database] = uri.path[1..-1]
        end
        config.delete(:simple_slave_url)
      end
    end

    def simple_slave_connection_spec
      return @simple_slave_spec unless @simple_slave_spec.nil?

      @simple_slave_spec = \
      ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.new(
        'slave' => simple_slave_configuration
      ).spec(:slave)
    end

    def simple_slave_connection_pool
      @simple_slave_connection_pool ||= \
        ActiveRecord::ConnectionAdapters::ConnectionPool.new(
          simple_slave_connection_spec
        )
    end

    def with_slave(&_block)
      retvalue = nil
      simple_slave_connection_pool.with_connection do |connection|
        begin
          Thread.current[:simple_slave_connection] = connection
          retvalue = yield(connection)
        ensure
          Thread.current[:simple_slave_connection] = nil
        end
      end
      retvalue
    end

    def connection
      if !Thread.current[:simple_slave_connection].nil?
        Thread.current[:simple_slave_connection]
      else
        super
      end
    end
  end
end
