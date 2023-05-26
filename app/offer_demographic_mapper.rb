class OfferDemographicMapper < ROM::Mapper
  relation    :offers_demographics
  register_as :offer_demographic

  model OfferDemographic

  attribute :offer_id
  attribute :demographic_id
end
