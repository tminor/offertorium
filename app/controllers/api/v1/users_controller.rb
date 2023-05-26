module Api
  module V1
    include Dry::Monads[:try]

    class UsersController < ApplicationController
      schema(:create) do
        required(:username).value(:string)
        required(:birth_date).value(:date)
        required(:gender).value(:string)
        required(:first_name).value(:string)
        required(:last_name).value(:string)
        required(:password).value(:string)
      end

      schema(:show) do
        required(:username).value(:string)
      end

      schema(:offers) do
        required(:username).value(:string)
      end

      private

      def repo
        UsersRepository.new(rom)
      end

      def model
        User
      end

      def relation
        repo.users
      end
    end
  end
end
