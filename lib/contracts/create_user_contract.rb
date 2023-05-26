class CreateUserContract < OffertoriumAPI::ApplicationContract
  params do
    required(:username).filled(:string)
    required(:birth_date).filled(:date)
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    required(:password).filled(:string)
  end
end
