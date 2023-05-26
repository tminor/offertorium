# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id, Integer

      column :username,   String, null: false, unique: true
      column :birth_date, Date,   null: false
      column :first_name, String, null: false
      column :gender,     String, null: false
      column :last_name,  String, null: false
      column :password,   String, null: false

      index %i[gender birth_date]
    end

    create_table :offers do
      primary_key :id, Integer

      column :name, String, null: false, unique: true
    end

    create_table :demographics do
      primary_key :id, Integer

      column :name,   String, null: false
      column :gender, String

      daterange :date_range

      unique %i[gender date_range]

      index %i[gender date_range]
    end

    create_table :offers_demographics do
      foreign_key :offer_id,       :offers
      foreign_key :demographic_id, :demographics

      primary_key %i[offer_id demographic_id]

      index %i[demographic_id offer_id]
    end

    create_table :users_demographics do
      foreign_key :user_id,        :users
      foreign_key :demographic_id, :demographics

      primary_key %i[user_id demographic_id]

      index %i[demographic_id user_id]
    end

    create_table :users_offers do
      foreign_key :user_id,  :users
      foreign_key :offer_id, :offers

      primary_key %i[user_id offer_id]

      index %i[offer_id user_id]
    end
  end
end
