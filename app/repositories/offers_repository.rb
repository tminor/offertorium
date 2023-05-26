class OffersRepository < Repository[:offers]
  def preprocess(offer)
    result = Try { offer.except(:target_demographic) }

    result.success? ? Success(result.value!) : Failure[:preprocessing_failed, :internal_server_error, result.exception]
  end

  def postprocess(offer)
    result = Try do
      combine_demographics(offer)
      combine_users(offer)
    end

    result.success? ? Success(result.value!) : Failure[:postprocessing_failed, result.exception]
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
    offers.combine(:demographics).by_pk(offer.id).map do |demographic|
      demographics.combine(:users).by_pk(demographic.id).users do |user|
        users_offers.changeset(:create)
                    .associate(user, :user)
                    .associate(offer, :offer)
                    .commit
      end
    end
  end

  def demographics_for(query)
    demographics.where do
      date_range.overlap(query[:date_range][:from]..query[:date_range][:to])
    end.where(query.except(:date_range))
  end
end
