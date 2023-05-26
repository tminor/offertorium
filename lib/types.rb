require 'dry-struct'

module Types
  include Dry::Types()

  class DateRange < Dry::Struct
    attribute :lower, Types::Strict::Date
    attribute :upper, Types::Strict::Date

    def exclude_begin?
      false
    end

    def exclude_end?
      false
    end
  end
end
