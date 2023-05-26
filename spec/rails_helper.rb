require 'spec_helper'
require 'pry'

ENV['RAILS_ENV'] ||= 'test'
ENV['DBURL'] ||= 'postgresql://postgres:password@localhost'

require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

RSpec.configure do |config|
  def db
    Sequel::DATABASES.first
  end

  def migrations_must_be_run!
    cmd = 'DBURL=postgresql://postgres:password@localhost rake db:migrate'
    raise "migrations mus be run first via `#{cmd}`"
  end

  config.before(:all) do
    migrations = db[:schema_migrations].order(Sequel.desc(:filename))
    migrations_must_be_run! if migrations.empty?

    last_migration_in_db = migrations.first[:filename]
    last_migration_in_fs = File.basename(Dir["#{Rails.root}/db/migrate/*"].max)

    migrations_must_be_run! if last_migration_in_fs != last_migration_in_db
  end

  config.before do
    db[*(db.tables - [:schema_migrations])].truncate
  end

  config.use_active_record = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
