class Item < ActiveRecord::Base
  # acts_as
  acts_as_list :scope => "project_id"
  
  # paperclip attachments
  has_attached_file :photo,
    :styles => {
      :thumb => "100x100#",
      :long   => "500x150#",
      :normal => "500x500>",
      :large => "600x600>"
    }
  
  # association statements
  belongs_to :project
  
  # validation statements
  validates_presence_of :name
  
  # paperclip specific validations
  # note these break the tests, don't know how to put these in rspec
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/gif']
  validates_attachment_size :photo, :less_than => 10.megabytes
  
  validates_each :date do |model, attr, value|
    begin
      DateTime.parse(value.to_s)
    rescue
      model.errors.add(attr, "date not valid")
    end
  end
  
  # re-order the items into the order the ids are passed in
  def self.order(ids)
    update_all(['position = FIND_IN_SET(id,?)', ids.join(',')], {:id => ids})
  end
end
