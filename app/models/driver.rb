# frozen_string_literal: true

class Driver < User
  include Mongoid::Document

  # Has the driver been trained?
  field :trained, type: Boolean, default: false
  # Driver's car information
  field :car_make, type: String
  field :car_model, type: String
  field :car_license_plate, type: String
  # If a driver declines an appt, this appt ID is entered into a blacklist to
  # prevent this driver from being reassigned the appointment
  field :blacklist, type: Array, default: []
  field :keep_schedule, type: Boolean, deafult: false

  # Embeds
  # A driver will have exactly 2 schedules, since they are able to set their
  # schedule up to 2 weeks out
  embeds_many :schedule
  accepts_nested_attributes_for :schedule

  # Belongs
  belongs_to :sysadmin, optional: true

  # Has
  has_many :appointments

  # Cleanup method for all driver blacklists that will find and remove any
  # appointments that are now in the past for every driver.
  def self.blacklist_reset
    Driver.each do |driver|
      to_del = []
      driver.blacklist.each do |bl|
        appt = begin
                 Appointment.find(bl)
               rescue StandardError
                 nil
               end
        if appt.nil?
          to_del.append(bl)
        elsif Time.parse(appt.datetime).past?
          to_del.append(bl)
        end
      end
      to_del.each do |d|
        driver.blacklist.delete(d)
      end
      driver.save
    end
  end
end
