require 'rails_helper'

RSpec.describe 'UsersRepository' do
  OffertoriumAPI::Container.finalize!

  let(:users_repo)        { UsersRepository.new(ROM.env) }
  let(:offers_repo)       { OffersRepository.new(ROM.env) }
  let(:demographics_repo) { DemographicsRepository.new(ROM.env) }

  let(:user_params) do
    {
      username: 'foobar',
      first_name: 'foo',
      last_name: 'bar',
      birth_date: '2000-01-01',
      password: 'password',
      gender: 'male'
    }
  end

  let(:offer_params) do
    {
      name: 'widgets',
      target_demographic: {
        date_range: { from: '2000-01-01', to: '2010-12-31' }
      }
    }
  end

  let(:demographic_params) do
    {
      name: 'zoomers',
      start_date: '1997-01-01',
      end_date: '2010-12-31',
      gender: 'male'
    }
  end

  context '#create' do
    it 'creates a user' do
      result = users_repo.create(user_params)

      expect(result.success?).to be_truthy
      expect(result.value!.first.id).to be_a Integer
    end

    it 'creates a user combined with matching offers' do
      demographics_repo.create(demographic_params)
      offers_repo.create(offer_params)
      offers_repo.create(
        {
          name: 'frobs',
          target_demographic: { date_range: { from: '1950-01-01', to: '1970-01-01' } }
        }
      )

      result = users_repo.create(user_params).value!.first
      user = users_repo.users.combine(:offers).by_pk(result.id).one

      offers = user.offers.map { |o| o[:name] }

      expect(offers).to eq [offer_params[:name]]
    end
  end
end
