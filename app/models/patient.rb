# frozen_string_literal: true

class Patient < User
  include Mongoid::Document

  field :approved, type: Boolean

  validates_presence_of :approved

  # Embeds
  # Each patient can save preset locations that they often use for future
  # reference
  embeds_many :location
  accepts_nested_attributes_for :location

  # Belongs
  belongs_to :healthcareadmin, optional: true

  # Has
  has_many :appointments
  has_many :comments
end
