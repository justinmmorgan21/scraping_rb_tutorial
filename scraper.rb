# tutorial from https://www.youtube.com/watch?v=GnVZexqtosc
require 'httparty'
require 'nokogiri'
require 'csv'

CSV.open(
  'books.csv', # filename
  'w+', # mode
  write_headers: true, # **options
  headers: %w[Title, Price, Availability]
) do |csv|

  50.times do |i| 
    response = HTTParty.get("https://books.toscrape.com/catalogue/page-#{i+1}.html")
    document = Nokogiri::HTML4(response.body)

    # if response.code == 200
    #   puts "okay"
    # else
    #   puts "error"
    # end

    all_books = document.css('article.product_pod')
    all_books.each { |book|
      title = book.css('h3 a').first['title']
      price = book.css('.price_color').text.delete('^0-9.')
      availability = book.css('.availability').text.strip 
      book = [title, price, availability]
      # puts book
      csv << book
    }
  end

end