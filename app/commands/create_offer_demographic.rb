class CreateOfferDemographic < ROM::Commands::Create[:sql]
  relation    :offers_demographics
  register_as :create
  result      :one
end
