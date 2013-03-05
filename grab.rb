#!/usr/bin/env ruby
require_relative 'grabber'

url = ARGV[0]; path = ARGV[1]

grab = Grabber.new url
grab.parse 
grab.download_to path