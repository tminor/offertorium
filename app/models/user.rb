class User < ApplicationModel
  attribute :username,   Types::Strict::String
  attribute :birth_date, Types::Strict::Date
  attribute :first_name, Types::Strict::String
  attribute :last_name,  Types::Strict::String

  def demographics
    association(:demographics)
  end

  def offers
    associate(:offers)
  end

  private

  def associate(key)
    UsersRepository.new(OffertoriumAPI::Container).users.combine(key).by_pk(id).one!
  end
end
