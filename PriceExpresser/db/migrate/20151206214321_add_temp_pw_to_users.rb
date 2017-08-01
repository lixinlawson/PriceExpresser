class AddTempPwToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tempPw, :string
  end
end
