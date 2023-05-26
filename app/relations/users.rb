class Users < ROM::Relation[:sql]
  gateway     :default
  auto_struct true

  schema(:users, infer: true) do
    associations do
      has_many :users_demographics
      has_many :demographics, through: :users_demographics

      has_many :users_offers
      has_many :offers, through: :users_offers
    end
  end
end
