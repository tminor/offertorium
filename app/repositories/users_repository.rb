class UsersRepository < Repository[:users]
  struct_namespace nil

  def postprocess(user)
    result = Try { [combine_demographics(user), combine_offers(user)] }

    result.success? ? Success[*result.value!] : Failure[:user_postprocessing_failed, :internal_server_error, result.exception]
  end

  def combine_demographics(user)
    demographics_for(user.to_h).map do |demographic|
      users_demographics.changeset(:create)
                        .associate(user, :user)
                        .associate(demographic, :demographic)
                        .commit
    end
  end

  def combine_offers(user)
    users.combine(:demographics).by_pk(user.id).demographics.map do |demographic|
      demographics.combine(:offers).by_pk(demographic[:id]).one.offers.map do |offer|
        users_offers.changeset(:create)
                    .associate(user, :user)
                    .associate(offer, :offer)
                    .commit
      end
    end
  end

  def by_username(username)
    result = Try { users.where(username:).one! }

    result.value? ? Success(result.value!) : Failure[:user_not_found, :not_found, result.exception]
  end

  def by_date_range(date_range)
    users.where { birth_date.in(date_range.lower..date_range.upper) }
  end

  def demographics_for(user)
    demographics.by_birth_date(user[:birth_date]).where(gender: user[:gender]).to_a
  end

  def with_demographics
    users.combine(:demographics)
  end

  def with_offers(user)
    result = Try { users.combine(:offers).where(user.to_h).one! }

    result.success? ? Success[result.value!, :ok] : Failure[:unable_to_find_offers, :internal_server_error, result.exception]
  end
end
