class OffersDemographics < ROM::Relation[:sql]
  gateway :default

  schema(:offers_demographics, infer: true) do
    associations do
      belongs_to :offer
      belongs_to :demographic
    end
  end
end
