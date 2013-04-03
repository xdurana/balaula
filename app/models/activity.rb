class Activity
  include Mongoid::Document
  field :code, type: String

  belongs_to :course
  has_and_belongs_to_many :resources
end
