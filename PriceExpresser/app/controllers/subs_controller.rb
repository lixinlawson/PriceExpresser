class SubsController < ApplicationController
  def create
    # @input = params[:expectedPrice]
       @product = Product.find_by_product_name(params[:product_id])
       @last_two = @product.subs.limit(2)
       @last_one = @last_two[0]
#
#       @test = @product.subs.where(:userId => current_user.id)
#
#       @ans = 'not run '
#
#       if @test == nil
#         @ans = 'it is nothing'
#       else
#         @ans = 'it is not nil'
#       end
#
#        if @product.subs.where(:userId => current_user.id) == nil
        @sub = @product.subs.create(sub_params)
        redirect_to product_path(@product)
#        else
#          @to_update = @product.subs.where(:userId => current_user.id)
#          @to_update.update(expectedPrice: @input)
#        end
      
  end
 
    private
      def sub_params
        params.require(:sub).permit(:userId, :expectedPrice, :notified)
      end
end
