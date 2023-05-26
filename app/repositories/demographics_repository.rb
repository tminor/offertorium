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

    result.success? ? Success(result.value!) : Failure(result)
  end

  def postprocess(demographic)
    result = Try do
      users(demographic.to_h).map do |user|
        users_demographics.changeset(:create)
                          .associate(demographic, :demographic)
                          .associate(user, :user)
                          .commit
      end

      result.success? ? Success(result.value!) : Failure[:postprocessing_failed, :internal_server_error, result.exception]
    end
  end

  def users(demographic)
    repo = UsersRepository.new(container)
    repo.by_date_range(demographic[:date_range])
        .where(gender: demographic[:gender])
        .to_a
  end

  def with_offers
    demographics.combine(:offers)
  end
end
