require 'rails_helper'

RSpec.describe 'OffersController', type: :request do
  describe 'POST /api/v1/offers' do
    let(:valid_params) do
      {
        name: 'widgets',
        target_demographic: {
          date_rage: {
            from: '1997-01-01',
            to: '2010-12-31'
          },
          gender: 'male'
        }
      }
    end

    context 'given valid params' do
      it 'responds with created status' do
        post '/api/v1/offers', params: valid_params

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
          post '/api/v1/offers',       params: valid_params

          expect(response).to have_http_status :created
        end
      end
    end
  end
end
