require 'Retriever'

class PricesController < ApplicationController
  include Retriever

  def create
    @product = Product.find(params[:product_id])
    @price = @product.prices.where(source: "Amazon")
    
    @price0 = @product.prices.create(price: "1099", source: "Walmart", url: "www.google.com")
    @price1 = @product.prices.create(price: "1199", source: "Amazon", url: "www.amazon.com")
    @price2 = @product.prices.create(price: "990", source: "Costco", url: "www.costco.com")
    
    @allall = retrieveAllInfo("macbook")
    redirect_to product_path(@product)
  end
  
	def index
    @product = Product.find(params[:product_id])
		@all = retrieveAllInfo(@product.product_name)
    render "index"
	end
  
  private
    def price_params
      params.require(:price).permit(:price, :source)
    end

end
