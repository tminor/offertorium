Dry::Rails.container do
  config.component_dirs.add 'app/commands'
  config.component_dirs.add 'app/mappers'
  config.component_dirs.add 'app/models'
  config.component_dirs.add 'app/relations'
  config.component_dirs.add 'app/repositories'

  config.component_dirs.add 'lib/contracts'
end
