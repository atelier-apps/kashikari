class AddNoteToContract < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :note, :text
  end
end
