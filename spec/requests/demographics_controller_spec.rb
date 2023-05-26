require 'rails_helper'

RSpec.describe 'DemographicsController', type: :request do
  describe 'POST /api/v1/demographics' do
    let(:valid_params) do
      {
        name: 'zoomers',
        start_date: '1997-01-01',
        end_date: '2012-12-31',
        gender: 'male'
      }
    end

    context 'given valid params' do
      it 'responds with created status' do
        post '/api/v1/demographics', params: valid_params

        expect(response).to have_http_status :created
      end

      context 'and a matching user' do
        it 'responds with created status' do
          user_params = {
            username: 'foobar',
            first_name: 'foo',
            last_name: 'bar',
            birth_date: '2020-01-01',
            password: 'password',
            gender: 'male'
          }

          post '/api/v1/users',        params: user_params
          post '/api/v1/demographics', params: valid_params

          expect(response).to have_http_status :created
        end
      end
    end

    context 'given invalid date range' do
      it 'responds with unprocessable identity' do
        invalid_params = {
          name: 'zoomers',
          end_date: '1997-01-01',
          start_date: '2012-12-31',
          gender: 'male'
        }

        post '/api/v1/demographics', params: invalid_params

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
