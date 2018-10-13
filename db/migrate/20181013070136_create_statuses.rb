class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :key
      t.string :japanese
      t.string :english

      t.timestamps
    end
  end
end
