class Course

  include Mongoid::Document

  field :id, type: String
  field :name, type: String

  has_and_belongs_to_many :documents
  
end
