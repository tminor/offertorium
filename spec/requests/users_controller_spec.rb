require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  let(:valid_params) do
    {
      username: 'foobar',
      first_name: 'foo',
      last_name: 'bar',
      birth_date: '2020-01-01',
      password: 'password',
      gender: 'male'
    }
  end

  describe 'POST /api/v1/users' do
    context 'given valid params' do
      it 'responds with created status' do
        post '/api/v1/users', params: valid_params

        expect(response).to have_http_status :created
      end

      context 'and a matching demographic' do
        it 'responds with created status' do
          demographic_params = {
            name: 'zoomers',
            start_date: '1997-01-01',
            end_date: '2010-12-31',
            gender: 'male'
          }
          post '/api/v1/demographics', params: demographic_params
          post '/api/v1/users', params: valid_params

          expect(response).to have_http_status :created
        end
      end
    end

    context 'given params with duplicate username' do
      it 'responds with conflict status' do
        dupe_params = {
          username: 'foobar',
          first_name: 'foo',
          last_name: 'bar',
          birth_date: '2020-01-01',
          password: 'password',
          gender: 'male'
        }

        post '/api/v1/users', params: valid_params

        post '/api/v1/users', params: dupe_params

        expect(response).to have_http_status :conflict
      end
    end

    context 'given invalid params' do
      it 'responds with unprocessable_entity status' do
        params = { useraname: 'foobar', birth_date: 1_684_862_943 }

        post '/api/v1/users', params: params

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'GET /api/v1/users' do
    context 'given a valid username' do
      it 'responds with ok status' do
        post '/api/v1/users', params: valid_params
        get '/api/v1/users', params: { username: 'foobar' }

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /api/v1/users/offers' do
    context 'given a valid username' do
      it 'responds with ok status and offers' do
        post '/api/v1/demographics', params: {
          name: 'foo',
          start_date: '2000-01-01',
          end_date: '2030-12-31',
          gender: 'male'
        }

        post '/api/v1/users', params: valid_params

        post '/api/v1/offers', params: {
          name: 'widgets',
          target_demographic: {
            date_range: {
              from: '2001-01-01',
              to: '2008-01-01'
            }
          }
        }

        get '/api/v1/users/offers', params: { username: 'foobar' }

        json = JSON.parse(response.body)

        offers = json['offers'].map { |o| o['name'] }

        expect(offers).to eq ['widgets']
      end
    end
  end
end
