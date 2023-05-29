require 'types'

class ApplicationController < ActionController::API
  include Dry::Monads[:result]

  before_action do
    render json: { errors: safe_params.errors.to_h }, status: :unprocessable_entity if safe_params&.failure?
  end

  def create
    result = repo.create(safe_params)

    response_for(result)
  end

  def show
    result = repo.query(safe_params.to_h)

    response_for(result)
  end

  def response_for(result)
    case result
    in Success[json, status]
      render json:, status:
    in Success(_)
      entity = relation.by_pk(result.value![:id]).one
      render json: entity, status: :ok
    in Failure[reason, status, errors]
      render json: { reason:, errors: }, status:
    in Failure(_)
      render json: { errors: result.failure }, status: 500
    end
  end
end
