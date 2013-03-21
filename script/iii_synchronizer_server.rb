#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'uri'

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def get_xrecord(bibid)
	uri = URI.parse(get_xrecord_url(bibid))
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
  response.body
end

def get_xrecord_url(bibid)
	'http://cataleg.uoc.edu/xrecord=' << bibid
end

bibids = [ "b1049068", "b1049069", "b1049070" ]
bibids.each do |bibid|
  xrecord = get_xrecord(bibid)
  resource = Resource.find_or_create_by(bibid: bibid)
  resource.name = bibid
  resource.save!
end