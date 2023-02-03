# Run 'gem install nokogiri' and 'gem install faraday' to install dependent library

require 'rubygems'
require 'nokogiri'
require 'faraday'

uri = "https://www.nasa.gov/api/2/ubernode/485152" #target endpoint
response = Faraday.get uri
body = response.body
json_transformed_data = JSON.parse(body)
article = json_transformed_data["_source"]
article_body = Nokogiri::HTML(article["body"]).text.delete("\n")
article_date = DateTime.parse(article["promo-date-time"]).strftime('%Y-%m-%d')
result_hash = {
	title: article["title"],
	date: article_date,
	release_no: article["release-id"],
	article: article_body
}

puts result_hash