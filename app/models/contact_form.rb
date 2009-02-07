class ContactForm < Tableless
  column :name, :string
  column :email, :string
  column :message, :text
  
  validates_presence_of :name, :email, :message
  include RFC822 # the module that contains the EmailAddress RegExp
  validates_format_of :email, :with => EmailAddress
end