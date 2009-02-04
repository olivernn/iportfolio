class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id, :null => false
      t.string  :location
      t.string  :email
      t.integer :phone
      t.boolean :freelance
      t.text    :skills
      t.string  :photo_file_name
      t.string  :photo_content_type
      t.integer :photo_file_size
      t.timestamps
    end
    
    add_index :profiles, :user_id
  end

  def self.down
    drop_table :profiles
  end
end
