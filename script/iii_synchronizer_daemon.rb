#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'daemons'

Daemons.run 'script/iii_synchronizer_server'