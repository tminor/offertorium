class CreateUserDemographic < ROM::Commands::Create[:sql]
  relation    :users_demographics
  register_as :create
  result      :one
end
