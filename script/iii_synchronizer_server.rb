#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'unicode'

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def text(s)
	unescape_unicode(s.text)
end

def unescape_unicode(s)
   s.gsub(/\{u(.{4})}/) {|m| [$1].pack("H*").unpack("n*").pack("U*")}
end

def get_xrecord_url(bibid)
	'http://cataleg.uoc.edu/xrecord=' << bibid
end

def get_xrecord_fields(xrecord, field, subfield)
	xrecord.xpath("//MARCTAG[text()='" << field << "']/../../MARCSUBFLD/SUBFIELDINDICATOR[text()='" << subfield << "']/../SUBFIELDDATA")
end

def get_xrecord_title(xrecord)
	text(get_xrecord_fields(xrecord, '245','a')) << " " <<
	text(get_xrecord_fields(xrecord, '245','b'))
end

def get_xrecord_courses(xrecord)
	get_xrecord_fields(xrecord, '690','a')
end

def get_xrecord_authors(xrecord)
	get_xrecord_fields(xrecord, '100','a')
end

def exists?(xrecord)
	xrecord.xpath("//NULLRECORD").empty?
end

def load_xrecord(bibid)
	xrecord = Nokogiri::XML(open(get_xrecord_url(bibid)))
	if exists?(xrecord)
	  resource = Resource.find_or_create_by(bibid: bibid)

	  #courses
		get_xrecord_courses(xrecord).each do |c|
			code = text(c).match(/(.*) \((.{2}\..{3})\)/) {|m|
				name = $1
				code = $2.sub(/\./,'')
				course = Course.find_or_create_by(code: code)
				course.name = name
				course.resources_count = course.resources.count
				course.save!
				resource.courses.push course
			}
		end

		#authors
		get_xrecord_authors(xrecord).each do |a|
			name = text(a)
			author = Author.find_or_create_by(name: name)
			author.save!
			resource.authors.push author
		end

		resource.bibid = bibid
		resource.name = get_xrecord_title(xrecord).sub(/ \//,'')
		resource.courses_count = resource.courses.count
  	resource.save!
	end
end

Resource.delete_all
Course.delete_all
Author.delete_all

for i in 1000001..1049930
	load_xrecord("b" << i.to_s)
end