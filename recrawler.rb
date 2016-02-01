require 'nokogiri'
require 'open-uri'
require 'csv'

class MissingPrice
	attr_reader :store, :sku, :pn, :url

  def initialize(store, sku, pn, url)
		@store = store
		@sku = sku
		@pn = pn
		@url = url
	end

  def parser
    @parser ||= Nokogiri::HTML(open(url, 'User-Agent' => 'chrome'))
  end

  def final_price
    begin
      new_price_lookup
    rescue
      "na"
    else
      new_price_lookup
    end
  end

  def final_stock
    begin 
      new_stock_lookup
    rescue
      "N"
    else
      new_stock_lookup
    end
  end

  def final_reseller
    begin
      new_reseller_lookup
    rescue
      "Not Listed"
    else
      new_reseller_lookup
    end
  end


  private
  def new_price_lookup
    case store.downcase
    when 'walmart.com'
      parser.css('div.js-product-add-lists-summary button')[0]['data-product-price'].match(/\d.+/)
    when 'tigerdirect.com'
      parser.css('span.salePrice')[0].text.match(/\d.+/)
	when 'officedepot.com'
	  parser.css('meta[itemprop="price"]')[0]['content']
    when 'rakuten'
      if parser.at_css('div#pricecurtain')
        parser.css('div#pricecurtain')[0]['data-price'].match(/\d.+/)
      else
      parser.css('div#float-price span.price')[0].text.match(/\d.+/)
      end
    when 'cdw'
      parser.css('div#primaryProductPurchaseInfoBlock span#singleCurrentItemLabel').text
    when 'pcconnection'
      parser.css('meta[itemprop="price"]')[0]['content'].match(/\d.+/)
    when 'target.com'
      parser.css('span.offerPrice')[0].text.match(/\d.+/)
    when 'bestbuy.com'
      parser.css('div.item-price')[0].text.match(/\d.+/)
    when 'redcoon de'
      parser.css('meta[itemprop="price"]')[0]['content']
    end
  end


  def new_stock_lookup
    case store.downcase
    when 'walmart.com'
      parser.css('meta[itemprop="availability"]')[0]['content']
    when 'tigerdirect.com'
      parser.css('dl.itemStock strong').text
    when 'officedepot.com'
      parser.css('div.deliveryMessage')[0].text.gsub(/\s+/,' ').strip
    when 'rakuten'
      parser.css('link[itemprop="availability"]')[0]['href']
    when 'cdw'
      parser.css('div#primaryProductAvailability').text
    when 'pcconnection'
      parser.css('div#ctl00_content_ucProductDetails_divStatusTitle')[0].text.gsub(/\s+/,' ').strip
    when 'target.com'
      parser.css('div.shipping')[0].text.gsub(/\s+/,' ').strip
    when 'bestbuy.com'
      parser.css('ul.availability-list div.sidebar-blurb-message')[0].text.gsub(/\s+/,' ').strip
    when 'redcoon de'
      parser.css('meta[itemprop="availability"]')[0]['content']
    end
  end

  def new_reseller_lookup
    case store.downcase
    when 'walmart.com'
      parser.css('div.product-seller b')[0].text
    when 'tigerdirect.com'
      'TigerDirect'
    when 'officedepot.com'
      'OfficeDepot.com'
    when 'rakuten'
      parser.css('span.text-seller strong')[0].text
    when 'cdw'
      'CDW'
    when 'pcconnection'
      'PCConecction'
    when 'target.com'
      'Target'
    when 'bestbuy.com'
      parser.css('div.marketplace-featured a')[0].text
     when 'redcoon de'
      'redcoon de'
    end
  end


end


contents = CSV.open "mp_lookup-input.csv", headers: true, header_converters: :symbol
contents.each do |row|

  product = MissingPrice.new(row[:store], row[:sku], row[:pn], row[:url])

  puts product.store, product.sku, product.pn, product.url, product.final_price, product.final_stock, product.final_reseller

  CSV.open("mp_lookup-output.csv", 'a+', headers: true, header_converters: :symbol) do |in_file|
    in_file << [product.store, product.sku, product.pn, product.url, product.final_price, product.final_stock, product.final_reseller]
  end
end
