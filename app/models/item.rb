class Item < ActiveRecord::Base
  # acts_as
  acts_as_list :scope => "project_id"
  
  # paperclip attachments have been moved into the Items subclasses
  
  # association statements
  belongs_to :project
  
  # validation statements
  validates_presence_of :name
  
  validates_each :date do |model, attr, value|
    begin
      DateTime.parse(value.to_s)
    rescue
      model.errors.add(attr, "date not valid")
    end
  end
  
  # overriding to_param method to get prettier urls
  def to_param
    "#{id}-#{name.parameterize.to_s}"
  end
  
  # re-order the items into the order the ids are passed in
  def self.order(ids)
    update_all(['position = FIND_IN_SET(id,?)', ids.join(',')], {:id => ids})
  end
end
