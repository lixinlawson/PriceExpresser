class SearchController < ApplicationController
  def search
  if params[:q].nil?
    @products = []
  else
    @products = Product.search params[:q]
  end
end
 
end
