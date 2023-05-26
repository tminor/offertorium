require 'dry-transaction'

class CreateUserTransaction
  include Dry::Transaction

  step :persist

  def persist(params)
    user = repo.create(params)

    Success(user)
  end

  private

  def repo
    OffertoriumAPI::Container['users_repository']
  end
end
