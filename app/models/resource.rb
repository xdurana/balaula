class Resource

  include Mongoid::Document

  field :name, type: String
  field :type, type: String

  has_and_belongs_to_many :courses

end
