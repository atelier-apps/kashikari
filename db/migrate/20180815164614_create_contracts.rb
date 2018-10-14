class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.bigint :friend_id
      t.bigint :user_id
      t.integer :amount
      t.bigint :status_id
      t.text :note
      t.date :deadline

      t.timestamps
    end
  end
end
