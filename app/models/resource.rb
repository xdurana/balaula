class Resource
  
  include Mongoid::Document
  
  field :name, type: String
  field :bibid, type: String
  field :raw, type: String
  field :courses_count, type: Integer, :default => 0
	
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :authors

	validates :name, :presence => true
end
