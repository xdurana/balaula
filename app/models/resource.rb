class Resource
  include Mongoid::Document
  include Mongoid::Search

 	field :name, type: String
  field :bibid, type: String
  field :raw, type: String
  field :courses_count, type: Integer, :default => 0
  field :attachment_uid

  file_accessor :attachment
	
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :resources
	has_and_belongs_to_many :authors

	validates :name, :presence => true

	search_in :name
end
