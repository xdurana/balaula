class Resource
  
  include Mongoid::Document
  
  field :name, type: String
  field :bibid, type: String
  field :raw, type: String
	
	has_and_belongs_to_many :courses

	validates :name, :presence => true
end
