class Profile < ApplicationRecord
  # Association
  belongs_to :person

  # Validations
  validates :first_name, :length => { :maximum => 32 }
  validates :last_name, :length => { :maximum => 32 }
  validates_format_of :first_name, :with => /\A[^;]+\z/, :allow_blank => true
  validates_format_of :last_name, :with => /\A[^;]+\z/, :allow_blank => true
end
