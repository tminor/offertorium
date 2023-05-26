module Api
  module V1
    class OffersController < ApplicationController
      schema(:create) do
        required(:name).value(:string)

        required(:target_demographic).schema do
          optional(:date_range).schema do
            required(:from).value(:date)
            required(:to).value(:date)
          end

          optional(:gender).value(:string)
        end
      end

      private

      def repo
        OffersRepository.new(rom)
      end

      def model
        Offer
      end

      def relation
        repo.offers
      end
    end
  end
end
