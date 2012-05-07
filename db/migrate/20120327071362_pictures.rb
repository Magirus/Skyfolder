class Pictures < ActiveRecord::Migration

  def change
    create_table :pictures do |t|
      t.string :file
      t.string :key
      t.integer :user_id
    end
  end
end
