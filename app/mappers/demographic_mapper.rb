class DemographicMapper < ROM::Mapper
  relation    :demographics
  register_as :demographic

  model Demographic

  attribute :date_range
  attribute :name
  attribute :gender
end
