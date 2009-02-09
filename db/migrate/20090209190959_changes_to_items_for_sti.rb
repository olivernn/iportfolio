class ChangesToItemsForSti < ActiveRecord::Migration
  def self.up
    add_column :items, :type, :string, :null => false
    rename_column :items, :photo_file_name, :source_file_name
    rename_column :items, :photo_content_type, :source_content_type
    rename_column :items, :photo_file_size, :source_file_size
  end

  def self.down
    remove_column :items, :type
    rename_column :items, :source_file_name, :photo_file_name
    rename_column :items, :source_content_type, :photo_content_type
    rename_column :items, :source_file_size, :photo_file_size
  end
end
