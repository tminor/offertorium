class CreateUserOffer < ROM::Commands::Create[:sql]
  relation    :users_offers
  register_as :create
  result      :one
end
