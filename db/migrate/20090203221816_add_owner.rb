class AddOwner < ActiveRecord::Migration
  def self.up
    # Create owner role
    owner_role = Role.create(:name => 'owner')
    
    # Create default admin user
    user = User.create do |u|
      u.login = 'anna'
      u.name = 'Anna Cole'
      u.password = u.password_confirmation = 'louise'
      u.email = 'anna@mail.com'
    end
    
    # Activate user
    user.register!
    user.activate!
    
    # Add admin role to admin user
    user.roles << owner_role
  end

  def self.down
    # destroy the owner role
    Role.find_by_name('owner').destroy
    
    # destroy the owner user
    User.find_by_login('anna').destroy
  end
end
