require 'nokogiri'
require 'open-uri'
require 'csv'

File.open ("mp_lookup-real.csv", 'r') do |file|
	file.readlines.each { |line|
		line.split(',')[4] = row_url
		goto_url = Nokogiri::HTML(open(row_url))
		new_price = goto_url.css('meta[itemprop="price"]')[0]['content'].delete '$'


#----
#In this section, I'm looking to write the value of new_price to the 5th column in the same csv file
	in_file = open("mp_lookup-real.csv", 'r+')
	in_file.write(new_price)[:price]
#----

end
