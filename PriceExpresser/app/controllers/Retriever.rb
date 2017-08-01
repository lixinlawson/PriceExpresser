module Retriever
	require 'time'
	require 'uri'
	require 'openssl'
	require 'base64'
	require 'open-uri'
	require 'json'
	
	def retrieveAllInfo(keywords)
		@walmartData = retrieveWalmart(keywords)
  		@amazonData = retrieveAmazon(keywords)
  		@ebayData = retrieveEbay(keywords)
  		
  		return @walmartData + @amazonData + @ebayData
	end

	def xmlRequest(params)
		@params = params
		# Your Product advertising API Access Key ID, as taken from the AWS Your Account page
		@AWS_ACCESS_KEY_ID = "AKIAIXPXCSPNVXEMNJEQ"

		# Your AWS Secret Key corresponding to the above ID, as taken from the AWS Your Account page
		@AWS_SECRET_KEY = "Cm8o84KUhbuOChjRJRbsugEUPxi85KSXkD7DBKRC"

		# The region you are interested in
		@ENDPOINT = "webservices.amazon.com"

		@REQUEST_URI = "/onca/xml"

		# Generate the canonical query
		@canonical_query_string = @params.sort.collect do |key, value|
		  [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
		end.join('&')

		# Generate the string to be signed
		# string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
		@string_to_sign = "GET\n"+@ENDPOINT+"\n"+@REQUEST_URI+"\n"+@canonical_query_string

		# Generate the signature required by the Product Advertising API
		@signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @AWS_SECRET_KEY, @string_to_sign)).strip()

		# Generate the signed URL
		@uriSign = URI.escape(@signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
		@request_url = "http://"+@ENDPOINT+@REQUEST_URI+"?"+@canonical_query_string+"&Signature="+@uriSign

		return @request_url

	end

	def retrieveAmazon(keywords)
		@params = {
		  "Service" => "AWSECommerceService",
		  "Operation" => "ItemSearch",
		  "AWSAccessKeyId" => "AKIAIXPXCSPNVXEMNJEQ",
		  "AssociateTag" => "AKIAIVL6LK7572V643YA",
		  "SearchIndex" => "All",
		  "Keywords" => keywords,
		  "ResponseGroup" => "Images,ItemAttributes,Offers"
		}
		# Set current timestamp if not set
		@params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

		@amazon_url = xmlRequest(@params)

		@doc = Nokogiri::XML(open(@amazon_url).read)
		@itemsets = @doc.search("Item")
		@AllItems = []
		@itemsets.each do |i|	
			@item = []
			@item.push i.at_css("Title").text
			@item.push i.at_css("DetailPageURL").text
			@item.push i.at_css("SmallImage").at_css("URL").text
			
			# @item.push i.at_css("Price").at_css("FormattedPrice").text
      
      if i.at_css("Price")==nil
        @item.push i.at_css("FormattedPrice").text
      else
        @item.push i.at_css("Price").at_css("FormattedPrice").text
      end
      
			@item.push "Amazon"
			@AllItems.push @item
		end
		return @AllItems
	end

	# Find ebay results
	def retrieveEbay(keywords)
		@searchLink = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=PriceExp-f125-47c6-8031-c8e9e80aae6c&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&keywords="+keywords+"&paginationInput.entriesPerPage=3"

		url = URI.parse(@searchLink)
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
				http.request(req)
		}		
		@start =res.body.index('(')
		@searchData = JSON.parse(res.body[@start+1..res.body.length-2])
		@ebayItems = @searchData["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]

		@AllItems = []
		@ebayItems.each do |a|
			@item = []
			@item.push a["title"][0]
			@item.push a["viewItemURL"][0]
			@item.push a["galleryURL"][0]			
			@item.push a["sellingStatus"][0]["currentPrice"][0]["__value__"]
			@item.push "eBay"
			@AllItems.push @item
		end
		return @AllItems
	end

	# Find Walmart results	
	def retrieveWalmart(keywords)
		@json = JSON.parse(open('http://api.walmartlabs.com/v1/search?apiKey=3x2pnsdfrrejqa46frc2kbuq&query='+keywords).read)
		@items = @json["items"]
		@AllItems = []
		@items.each do |a|
			@item = []
			@titles =  a["name"]
			@salePrices = a["salePrice"]
			@images = a["thumbnailImage"]
			@urls = a["productUrl"]

			@item.push @titles
			@item.push @urls
			@item.push @images
			@item.push "$"+@salePrices.to_s
			@item.push "Walmart"
			@AllItems.push @item
		end
		return @AllItems
	end
end