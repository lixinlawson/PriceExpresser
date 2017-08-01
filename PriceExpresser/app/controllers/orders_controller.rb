class OrdersController < ApplicationController

	before_filter do
	    if current_user.nil? 
	      redirect_to '/login'
	    end
  	end

	def index
		# Get subscriptions 
		@id = current_user.id
		@subscriptions = Sub.where(:userId => current_user.id)

		if @subscriptions != nil
			@items = []
			@subscriptions.each do |s|			
				@products = Product.where(:id => s.product)	# Find related products by id
				@products.each do |p|
					@item = []
					@item.push p.product_name
					@item.push p.description
					@item.push s.expectedPrice
					@item.push s.id
					@item.push @products
					@items.push @item
				end
				
			end
		end
	end

	def update
		@sub = Sub.find(params[:id])
		@input = params[:q]
		@sub.update(expectedPrice: @input)
		@sub.update(notified: 0)
		redirect_to orders_path
	end

	def destroy
		# delete the chosen item
		@sub = Sub.find(params[:id])
	  	@sub.destroy
	 
	  	redirect_to orders_path
	end

end
