class Comment
  include Mongoid::Document

  # The user ID of the user that made the comment
  field :author, type: String
  field :text, type: String
  # If this field is true, the comment was created through the 'Report Issue'
  # button
  field :is_report, type: Boolean

  # Comments can belong to a patient in the case that a driver/volunteer/admin
  # is making a comment about the patient.
  belongs_to :patient, optional: true
end
