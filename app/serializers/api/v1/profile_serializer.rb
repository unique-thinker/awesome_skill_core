class Api::V1::ProfileSerializer < Api::ApplicationSerializer
  attributes :first_name,
             :last_name,
             :birthday,
             :gender,
             :status,
             :bio,
             :professions,
             :company,
             :current_place,
             :native_place,
             :state,
             :country
  # belongs_to :person
  meta do |profile|
    {
      country_data: profile.country_with_states
    }
  end
end
