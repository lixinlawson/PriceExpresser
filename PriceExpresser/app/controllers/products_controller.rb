require 'Retriever'
require 'uri'
class ProductsController < ApplicationController
  include Retriever
  
 def new
  @product = Product.new
 end
 def edit
  @product = Product.find_by_product_name(params[:id])
 end
 
 def statAmazon #add statistical graph, this handle will redirect this page to graph
  @product = Product.find_by_product_name(params[:id])
  @product_amazon = Product.find_by_product_name(params[:id]).prices.where(:source => 'Amazon')
 end 

 def statEBay #add statistical graph, this handle will redirect this page to graph
  @product = Product.find_by_product_name(params[:id])
  @product_ebay = Product.find_by_product_name(params[:id]).prices.where(:source => 'eBay')
 end

  def statWalmart #add statistical graph, this handle will redirect this page to graph
  @product = Product.find_by_product_name(params[:id])
  @product_walmart = Product.find_by_product_name(params[:id]).prices.where(:source => 'Walmart')
 end

def index

  @products_others = Product.where(:category => 'others')
  @products_appliances = Product.where(:category => 'appliances')
  @products_electronic = Product.where(:category => 'electronic')
  @products_all = Product.all
 end
 def index_others
  @products_others1 = Product.where(:category => 'others')
  render "category_other"
 end
 def index_appliances
  @products_appliances1 = Product.where(:category => 'appliances')
  render "category_app"
 end
 def index_electronic
  @products_electronic1 = Product.where(:category => 'electronic')
  render "category_ele"
 end
 def create
  @product = Product.new(product_params)
 
  if @product.save
    redirect_to @product
  else
    render 'new'
  end
 end
 def show
  @product = Product.find_by_product_name(params[:id])
  @product_last = @product
  
  #@price0 = @product.prices.create(price: "1099", source: "Walmart", url: "www.google.com")
  @amazon = retrieveAmazon(@product.product_name)
  @amazon_first = @amazon[0]
  @amazon_first_name = @amazon_first[0]
  @amazon_first_source = @amazon_first.last
  @amazon_first_price = @amazon_first[3]
  @aoazon_first_url = @amazon_first[1]
  @price_amazon = @product.prices.create(price: @amazon_first_price, source: @amazon_first_source, url: @aoazon_first_url, img: @amazon_first[2])
  
  @ebay = retrieveEbay(URI.encode(@product.product_name))
  @ebay_first = @ebay[0]
  @price_ebay = @product.prices.create(price: "$" + @ebay_first[3], source: @ebay_first.last, url: @ebay_first[1], img: @ebay_first[2])
  
  @walmart = retrieveWalmart(URI.encode(@product.product_name))
  @wal_first = @walmart[0]
  @price_wal = @product.prices.create(price: @wal_first[3], source: @wal_first.last, url: @wal_first[1], img: @wal_first[2])

  
  @amazon_price = @amazon_first_price.tr('$,', '')
  @a_p = @amazon_price.to_f
  @walmart_price = @wal_first[3].tr('$,', '')
  @w_p = @walmart_price.to_f
  @ebay_price = @ebay_first[3].tr('$,', '')
  @e_p = @ebay_price.to_f
  
  if @product.subs.where(userId: current_user.id).last != nil
   @expectedP = @product.subs.where(userId: current_user.id).last.expectedPrice
   @expected_p = @expectedP.to_f
   
  if [@a_p,@w_p,@e_p].min < @expected_p
    UserMailer.PriceNotification(current_user).deliver
  end
end
#
#
 end
 def update
  @product = Product.find_by_product_name(params[:id])
  if @product.update(product_params)
    redirect_to @product
  else
    render 'edit'
  end
 end
 def destroy
  @product = Product.find_by_product_name(params[:id])
  @product.destroy
 
  redirect_to products_path
 end
private
  def product_params
    params.require(:product).permit(:product_name, :category, :description)
  end
 
end
