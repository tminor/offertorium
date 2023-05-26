module Api
  module V1
    class DemographicsController < ApplicationController
      schema(:create) do
        required(:start_date).value(:date)
        required(:end_date).value(:date)
        required(:name).value(:string)
        required(:gender).value(:string)
      end

      private

      def repo
        DemographicsRepository.new(rom)
      end

      def model
        Demographic
      end

      def relation
        repo.demographics
      end
    end
  end
end
