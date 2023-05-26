class UsersOffers < ROM::Relation[:sql]
  gateway :default

  schema(:users_offers, infer: true) do
    associations do
      belongs_to :user
      belongs_to :offer
    end
  end
end
