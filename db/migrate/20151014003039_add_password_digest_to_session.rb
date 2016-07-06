class AddPasswordDigestToSession < ActiveRecord::Migration
  def change
  	add_column :sessions, :password_digest, :string
  	remove_column :sessions, :password
  end
end
