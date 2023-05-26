class Demographic < ApplicationModel
  attribute :date_range, ROM::SQL::Postgres::Types::DateRange
  attribute :name,       Types::Strict::String
  attribute :gender,     Types::Strict::String

  def offers
    DemographicsRepository.new(container).combine(:offers).by_pk(id).one!
  end
end
