class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string, default: "はじめましての人"
    add_column :users, :description, :string
    add_column :users, :image, :string
  end
end
