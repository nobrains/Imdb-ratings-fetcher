require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
class IMDBRatings
	directory_to_parse = ARGV[0]
  uri = URI.parse("http://imdbapi.com")  
  http = Net::HTTP.new(uri.host, uri.port)
  http.open_timeout = 300
  http.read_timeout = 300
	data =  `ls #{directory_to_parse.chomp}`
  data.each do |file|
		file = file.chomp
		file_extension = File.extname(file)
		file = file.sub(file_extension,'')
		index_of_year = file.to_s =~ (/([1-2]{1}[0-9]{3})/)
		movie_year = ""
		movie_year = $1 if $1
		#puts index_of_year
		file = file.to_s[0,index_of_year-1] if index_of_year
		%w[, - \\\[ .].each do |special_character|
			index = file.to_s =~ (/[#{special_character}]/)
			file = file.to_s[0,index] if index		
		end
		#puts file
		#puts movie_year
    requestURI = "/?i=&t="+file.to_s.gsub(" ","+")+"&y=#{movie_year}"
    response = http.request(Net::HTTP::Get.new(requestURI))
    result = JSON.parse(response.body)  
    print ("#{result["Title"]} rating is: " + result.fetch("Rating") + "\n") if result["Rating"]
		puts file+": N/A" if !result["Rating"]
		end
end
