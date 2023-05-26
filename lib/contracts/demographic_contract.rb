class DemographicContract < OffertoriumAPI::ApplicationContract
  params do
    required(:start_date).filled(:date)
    required(:end_date).filled(:date)
    required(:name).filled(:string)
    required(:gender).filled(:string)

    rule(valid_range: %i[end_date start_date]) do |end_date, _|
      end_date.gt?(value(:start_date))
    end
  end
end
