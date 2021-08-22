# frozen_string_literal: true

# Abstract class Admin serves as the
class Admin < User
  include Mongoid::Document

  field :approved, type: Boolean

  validates_presence_of :approved
end
