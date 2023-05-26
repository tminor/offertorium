source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'rails', '~> 7.0.1'

gem 'puma', '~> 5.0'

# https://github.com/rom-rb/rom-rails/pull/130
gem 'rom-rails', git: 'https://github.com/nolantait/rom-rails', branch: 'rails-7-nt'

gem 'rom'
gem 'rom-repository'
gem 'rom-sql'

gem 'dry-container'
gem 'dry-monads'
gem 'dry-rails'
gem 'dry-system'
gem 'dry-transaction'
gem 'dry-validation', '~> 1.9'

gem 'pg'

gem 'bootsnap', require: false

group :development, :test do
  gem 'database_cleaner-sequel'

  gem 'rspec-rails'
end

group :development do
  # https://github.com/ruby-debug/debase/issues/102
  gem 'debase', '~> 0.2.5.beta2', require: false
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'rake'
  gem 'rdoc'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'solargraph'
end
