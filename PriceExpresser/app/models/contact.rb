class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  def headers
    {
      :subject => "Message From PriceExpresser",
      :to => "priceexpress9@gmail.com",
      :from => %("#{name}" <#{email}>)
      # group9PriceExpress
    }
  end
end