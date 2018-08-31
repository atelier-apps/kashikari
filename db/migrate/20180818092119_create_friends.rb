class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.bigint :user_id
      t.text :name

      t.timestamps
    end
  end
end
