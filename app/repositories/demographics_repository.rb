class DemographicsRepository < Repository[:demographics]
  def validate(params)
    result = DemographicContract.new.call(params)

    result.success? ? result : Failure[:validation_failed, :unprocessable_entity, result.errors.to_h]
  end

  def preprocess(params)
    result = Try do
      processed = params.except(:start_date, :end_date)

      processed[:date_range] = Types::DateRange.new(lower: params[:start_date], upper: params[:end_date])

      processed
    end

    result.success? ? Success(result.value!) : Failure[:demographic_preprocessing_failed, :internal_server_error, result.exception]
  end

  def postprocess(demographic)
    result = Try do
      users_for(demographic.to_h.except(:name)).map do |user|
        users_demographics.changeset(:create)
                          .associate(demographic, :demographic)
                          .associate(user, :user)
                          .commit
      end

    end

    result.success? ? Success(result.value!) : Failure[:demographic_postprocessing_failed, :internal_server_error, result.exception]
  end

  def users_for(demographic)
    query = users.where(demographic.except(:date_range))

    return query unless demographic[:date_range]

    query.where { birth_date > demographic[:date_range][:lower] }
         .where { birth_date < demographic[:date_range][:lower] }
  end

  def with_offers
    demographics.combine(:offers)
  end
end
