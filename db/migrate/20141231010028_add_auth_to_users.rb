class AddAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :surname, :string
    add_column :users, :forename, :string
    add_column :users, :token, :string
  end
end
