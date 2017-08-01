# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
namespace :csv do
	# desc "Import Inital Data"
	# task :import_text => :enviroment do
		csv_file_path = 'db/stores.csv'
		CSV.foreach(csv_file_path) do |store|
			location = Location.create({:name => store[0], :address => store[1], :phone => store[2]})
			if String.try_convert(location.name).include? "Walmart"
				location.update({:catalog => "walmart", :title =>"walmart"})
			elsif String.try_convert(location.name).include? "Costco"
				location.update({:catalog => "costco", :title => "costco"})
			elsif String.try_convert(location.name).include? "Best"
				location.update({:catalog => "bestbuy", :title => "bestbuy"})
			elsif String.try_convert(location.name).include? "Superstore"
				location.update({:catalog => "superstore", :title => "superstore"})	
			else
				location.update({:catalog => "otherstore"})	
			end		
		end
	# end
end