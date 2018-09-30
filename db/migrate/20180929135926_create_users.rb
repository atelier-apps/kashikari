class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :lineid
      t.text :name

      t.timestamps
    end
  end
end
