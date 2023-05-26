class UsersDemographics < ROM::Relation[:sql]
  gateway :default

  schema(:users_demographics, infer: true) do
    associations do
      belongs_to :user
      belongs_to :demographic
    end
  end
end
