#!/usr/bin/env ruby
require 'open-uri'

class Grabber
	IMG = /<img(\s+|\s[^>]+\s)src\s*=\s*[\"']?([^\s\"']+)[\"']?/

	def initialize url
		@links = []
		if url.include? "://"
			p = URI.parse(url)
			@addr = "#{p.scheme}://#{p.host}:#{p.port}"
			@url = url
		else
			@addr = "http://#{url.split('/')[0]}"
			@url = "http://#{url}"
		end
	end

	def parse text=nil
		text ||= open(@url).read
		while md = IMG.match(text)
			@links << if md[2].include?("://") then md[2] else @addr + md[2] end
			text = md.post_match
		end
	end

	def download_to path
		@links.each do |link|	
			img_name = File.basename link
			begin 
				open(link, 'rb') do |img| 
					File.new("#{path}/#{img_name}", 'wb').write(img.read)
				end
			rescue Exception => e
				next
			end	
		end
	end
end