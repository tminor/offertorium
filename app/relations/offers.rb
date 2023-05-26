class Offers < ROM::Relation[:sql]
  gateway :default

  schema(:offers, infer: true) do
    associations do
      has_many :offers_demographics
      has_many :demographics, through: :offers_demographics
    end
  end
end
