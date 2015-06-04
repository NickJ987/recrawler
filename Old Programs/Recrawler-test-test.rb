require 'nokogiri'
require 'open-uri'
require 'csv'

#contents = CSV.open "mp_lookup-input.csv", headers: true, header_converters: :symbol
#contents.each do |row|
	row_url = "http://www.walmart.com/ip/HP-11.6-Stream-Laptop-PC-with-Intel-Celeron-Processor-2GB-Memory-32GB-Hard-Drive-Windows-8.1-and-Microsoft-Office-365-Personal-1-yr-subscription/39073484"
	goto_url = Nokogiri::HTML(open(row_url))
	new_price = goto_url.css('meta[itemprop="price"]')[0]['content'].delete '$'

	if new_price.is_a? String
		puts new_price
	else
		puts "Unknown"
	end
