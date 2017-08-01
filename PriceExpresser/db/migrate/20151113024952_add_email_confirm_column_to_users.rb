class AddEmailConfirmColumnToUsers < ActiveRecord::Migration
  def change
  	#add column for email confirmation
    add_column :users, :email_confirmed, :boolean, :default => false
    add_column :users, :confirm_token, :string
  end
end
