require 'nokogiri'
require 'open-uri'
require 'csv'

class Recrawler
end

def walmart
  puts 'walmart'
  adsf
end

walmart

contents = CSV.open "mp_lookup-input.csv", headers: true, header_converters: :symbol
contents.each do |row|

#-- Define some variables

  row_store = row[:store]
  row_sku = row[:sku]
  row_pn = row[:pn]
  row_url = row[:url]

	goto_url = Nokogiri::HTML(open(row_url))

#-- Define some variables specific to Walmart.com
#---PRICE
  if goto_url.at_css('meta[itemprop="price"]')
  	new_price = goto_url.css('meta[itemprop="price"]')[0]['content'].sub("$","")
  else
  	new_price = "na"
  end

  #---STOCK STATUS
  if goto_url.at_css('meta[itemprop="availability"]')
  	stock = goto_url.css('meta[itemprop="availability"]')[0]['content']
  else
  	stock = "Check Status"
  end

  #---RESELLER
  if goto_url.at_css('div.product-seller')
  	reseller = goto_url.css('div.product-seller b')[0].text
  else
  	reseller = "Not Listed"
  end

  #-- End Walmart Variables

  #-- Put stuff to the console so I know things are happening

  puts row_store, row_sku, row_pn, row_url, new_price, stock, reseller

  #-- Append the data from the input file to the output file, as well as write the new data from new_price, stock, and reseller

  CSV.open("mp_lookup-output.csv", 'a+', headers: true, header_converters: :symbol) do |in_file|
  	in_file << [row_store, row_sku, row_pn, row_url, new_price, stock, reseller]
  end
end
