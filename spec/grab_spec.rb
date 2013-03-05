require_relative '../grabber'

class Grabber 
	attr_accessor :url, :addr, :links
end

describe "Grabber" do
	describe "initialize method" do 
		before :all do
			@grab1 = Grabber.new("http://localhost:3000/cars/1")
			@grab2 = Grabber.new("localhost:3000/cars/1")			
		end

		it "parses correct site address" do 
			@grab1.addr.should eq("http://localhost:3000")
			@grab2.addr.should eq("http://localhost:3000")
		end

		it "parses correct url" do 
			@grab1.url.should eq("http://localhost:3000/cars/1")
			@grab2.url.should eq("http://localhost:3000/cars/1")
		end
	end

	describe "parse method" do
		before :all do
			@text1 = <<-EOS
				<div class="message">
        		<img alt="Rails" src="/images/rails.png"/>
   	 		<img src="/images/headers/overview.gif" alt="Web development that doesn't hurt"/>
   	 	EOS
   	 	@text2 = "<div class='message'><img src='/images/rails.png' height='112' alt='Rails'/> "
        	@text3 = "<img src=/headers/overview.gif />"
		end

		before :each do 
			@grab = Grabber.new ""
			@addr = @grab.addr
		end

		it "parses correct image src attribute with double quotes" do
			@grab.parse @text1
			@grab.links.should eq ["#{@addr}/images/rails.png", "#{@addr}/images/headers/overview.gif"]
		end

		it "parses correct image src attribute with single quotes" do
			@grab.parse @text2
			@grab.links.should eq ["#{@addr}/images/rails.png"]
		end

		it "parses correct image src attribute without quotes" do
			@grab.parse @text3
			@grab.links.should eq ["#{@addr}/headers/overview.gif"]
		end
	end

	describe "download_to method" do
		before :all do
			@grab = Grabber.new ""
			@grab.links = ["img/ruby.gif", "img/download.gif"]
		end

		it "all files downloaded correctly" do
			@grab.download_to "tmp"
			Dir.chdir "tmp"
			Dir.glob("*").should =~ ["ruby.gif", "download.gif"]
		end
	end
end