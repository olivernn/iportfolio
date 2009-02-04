class Profile < ActiveRecord::Base
  # paperclip attachements
  has_attached_file :photo,
    :styles => {
      :sidebar => '170x170>'
    }
    
  # association statements
  belongs_to :user
  
  # validation statements
  validates_presence_of :email
  include RFC822 # the module that contains the EmailAddress RegExp
  validates_format_of :email, :with => EmailAddress
  validates_numericality_of :phone, :allow_nil => true
    
  # paperclip specific validations
  # note these break the tests, don't know how to put these in rspec
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => 'image/jpeg'
  validates_attachment_size :photo, :less_than => 5.megabytes
end
