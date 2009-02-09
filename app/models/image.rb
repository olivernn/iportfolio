class Image < Item
  # associations
  belongs_to :project
  
  # paperclip attachements
  has_attached_file :source,
    :styles => {
      :thumb => "100x100#",
      :long   => "500x150#",
      :normal => "500x500>",
      :large => "600x600>"
    }
  
  # paperclip validations, these break the rspec tests
  validates_attachment_presence :source # need to have an attachment
  validates_attachment_content_type :source, :content_type => 'image/jpeg' # only allowing jpegs to be uploaded
  validates_attachment_size :source, :less_than => 5.megabytes # images can only be 5MB max
end
