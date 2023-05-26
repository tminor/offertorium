class Demographics < ROM::Relation[:sql]
  gateway :default

  schema(:demographics, infer: true) do
    attribute :date_range, ROM::SQL::Postgres::Types::DateRange

    associations do
      has_many :offers_demographics
      has_many :offers, through: :offers_demographics

      has_many :users_demographics
      has_many :users, through: :users_demographics
    end
  end

  def with_offers
    combine(:offers)
  end

  def by_birth_date(birth_date)
    where { date_range.contain(birth_date..birth_date) }
  end
end
