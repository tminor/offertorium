class Repository < ROM::Repository::Root
  include Dry::Monads[:result]
  include Dry::Monads[:try]
  include Dry::Monads::Do.for(:insert)

  include OffertoriumAPI

  def create(params)
    result = insert(params)

    case result
    in Success(entity)
      Success[root.fetch(entity.id), :created]
    in Failure[*]
      result
    in Failure(_)
      result
    end
  end

  def insert(params)
    transaction do
      @validated    = yield validate(params.to_h)
      @preprocessed = yield preprocess(@validated.to_h)
      @staged       = yield stage(@preprocessed)

      @persisted = yield persist(@staged)

      postprocess(@persisted)

      Success(@persisted)
    end
  end

  def validate(params)
    Success(params)
  end

  def preprocess(params)
    Success(params)
  end

  def stage(params)
    result = Try { root.changeset(:create, params) }

    error = :"staging_#{root.name}_failed"
    result.value? ? Success(result.value!) : Failure[error, :internal_server_error, result.exception]
  end

  def postprocess(params)
    Success(params)
  end

  def persist(staged)
    result = Try { staged.commit }

    error = :"unable_to_persist_#{root.name}"
    result.value? ? Success(result.value!) : Failure[error, :conflict, result.exception]
  end

  def by_id(id)
    result = Try { root.by_pk(id).one! }

    error = :"#{root.name}_not_found"
    result.value? ? Success(result.value!) : Failure[error, :not_found, result.exception]
  end

  def all
    root.to_a
  end

  def query_one(conditions)
    result = Try { root.where(conditions).one! }

    error = :"#{root.name}_not_found"
    result.value? ? Success(result.value!) : Failure[error, :not_found, result.exception]
  end

  def query(conditions)
    result = Try { root.where(conditions).one! }

    error = :"#{root.name}_not_found"
    result.success? ? Success(result.value!) : Failure[error, :not_found, result.exception]
  end
end
