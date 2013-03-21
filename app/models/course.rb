class Course

  include Mongoid::Document

  field :code, type: String
  field :name, type: String
  field :_id, type: String, default: -> {code}

  has_and_belongs_to_many :resources

  validates :code, :name, :presence => true
end
