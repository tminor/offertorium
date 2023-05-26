class OfferMapper < ROM::Mapper
  relation :offers
  register_as :offer

  model Offer

  attribute :id
  attribute :name
  attribute :demographic_id
end
