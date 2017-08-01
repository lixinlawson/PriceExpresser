class ContactsController < ApplicationController
  def index
  	@contact = Contact.new
  	render :new
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.deliver
      flash.now[:success] = 'Thank you for your message. We will contact you soon!'
      
      
      render 'welcome/index'
    else
      flash,now[:error] = 'Cannot send message.'
      render :new
    end
  end
end