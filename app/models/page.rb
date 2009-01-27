class Page < ActiveRecord::Base
  # model call back methods
  before_validation_on_create :create_permalink
  
  # validation statements
  validates_presence_of :name, :permalink, :content
  validates_uniqueness_of :permalink
  
  # acts_as declarations
  acts_as_textiled :content
  
  # creating the permalink from the name before it is created
  def create_permalink
    self.permalink = CGI.escape(self.name.gsub(' ', '_')) if self.name
  end
  
  # getting the page for display
  def self.display(search_term)
    if search_term[:permalink]
      find_by_permalink(search_term[:permalink])
    else
      find(search_term[:id])
    end
  end
end
