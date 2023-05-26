class DemographicContract < OffertoriumAPI::ApplicationContract
  params do
    required(:start_date).filled(:date)
    required(:end_date).filled(:date)
    required(:name).filled(:string)
    required(:gender).filled(:string)
  end

  rule(:end_date, :start_date) do
    key.failure('must be after start date') if values[:end_date] < values[:start_date]
  end
end
