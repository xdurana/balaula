#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'open-uri'

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def get_xrecord_url(bibid)
	'http://cataleg.uoc.edu/xrecord=' << bibid
end

def get_xrecord_field(xrecord, field, subfield)
	xrecord.xpath("//MARCTAG[text()='${field}']/../../MARCSUBFLD/SUBFIELDINDICATOR[text()='${subfield}']/../SUBFIELDDATA")
end

bibids = [ "b1049068"]#, "b1049069", "b1049070" ]
bibids.each do |bibid|
  resource = Resource.find_or_create_by(bibid: bibid)

	xrecord = Nokogiri::XML(open(get_xrecord_url(bibid)))
	puts get_xrecord_field(xrecord, '245','a')

	#resource.name = get_xrecord_field(xrecord, '245','a')
  #resource.raw = Hash.from_xml(xrecord)
  resource.save!
end