class UserMapper < ROM::Mapper
  relation    :users
  register_as :user

  model User

  attribute :id
  attribute :username
  attribute :birth_date
  attribute :first_name
  attribute :last_name
  attribute :password
end
