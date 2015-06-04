require 'nokogiri'
require 'open-uri'


page_url = "http://www.amazon.com/gp/product/B00RH69VT6/ref=ms_sbrspot_0?pf_rd_p=2078207322&pf_rd_s=merchandised-search-top-4&pf_rd_t=101&pf_rd_i=11392907011&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=0H3FM709RMSBRSD8483C"

page = Nokogiri::HTML(open(page_url))

price = page.css('span#priceblock_ourprice')[0].text

puts price.sub("$","")

