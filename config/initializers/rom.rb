ROM::Rails::Railtie.configure do |config|
  config.gateways[:default] = [
    :sql, ENV.fetch('DBURL'), { extensions: %i[pg_range] }
  ]
end
