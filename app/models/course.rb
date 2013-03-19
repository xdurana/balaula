class Course

  include Mongoid::Document

  field :name, type: String

  has_and_belongs_to_many :resources

  validates :name, :presence => true
end
