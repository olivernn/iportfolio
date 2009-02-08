class ChangePhoneToString < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :phone
    add_column :profiles, :phone, :string
  end

  def self.down
    remove_column :profiles, :phone
    add_column :profiles, :phone, :integer
  end
end
