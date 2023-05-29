class OffersRepository < Repository[:offers]
  def preprocess(offer)
    result = Try { offer.except(:target_demographic) }

    result.success? ? Success(result.value!) : Failure[:offers_preprocessing_failed, :internal_server_error, result.exception]
  end

  def postprocess(offer)
    result = Try do
      [combine_demographics(offer), combine_users(offer)]
    end

    result.success? ? Success[*result.value!] : Failure[:offers_postprocessing_failed, result.exception]
  end

  def combine_demographics(offer)
    demographics_for(@validated.to_h[:target_demographic]).map do |demographic|
      offers_demographics.changeset(:create)
                         .associate(offer, :offer)
                         .associate(demographic, :demographic)
                         .commit
    end
  end

  def combine_users(offer)
    offers.by_pk(offer[:id]).combine(:demographics)&.demographics&.map do |demographic|
      demographics.by_pk(demographic[:id]).combine(:users).one.users.map do |user|
        users_offers.changeset(:create)
                    .associate(user, :user)
                    .associate(offer, :offer)
                    .commit
      end
    end
  end

  def demographics_for(target)
    query = demographics.where(target.except(:date_range))

    return query unless target[:date_range]

    query.where { date_range.overlap(target[:date_range][:from]..target[:date_range][:to]) }
  end
end
