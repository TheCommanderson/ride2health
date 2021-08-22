# frozen_string_literal: true

class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  # Nickname of the address
  field :name, type: String
  # Address fields
  field :addr1, type: String
  field :addr2, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: Integer
  # Information retrieved by Geocoder
  field :address, type: String
  field :coordinates, type: Array

  validates_presence_of :addr1, :city, :state
  validates_length_of :zip, minimum: 5, maximum: 5

  # Embeds
  embedded_in :Appointment
  embedded_in :Patient

  # Callbacks
  before_save :generate_full_address

  protected

  def generate_full_address
    temp_address = "#{addr1} #{addr2}, #{city}, #{state} #{zip}"
    result = Geocoder.search(temp_address)
    self.coordinates = result.first.coordinates
    self.address = result.first.address
  end
end
