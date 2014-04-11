class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :remember_token, :string
  	#Incude because you will search users database via a remember_token
  	add_index :users, :remember_token
  end
end
