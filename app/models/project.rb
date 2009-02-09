require 'aasm'
class Project < ActiveRecord::Base
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :draft
  
  aasm_state :draft
  aasm_state :active
  aasm_state :removed
  
  # publishing a project moves the status from draft to active, it also moves a project from removed to active
  aasm_event :publish do
    transitions :to => :active, :from => [:draft, :removed]
  end
  
  # removing a project moves the status from active to removed
  aasm_event :remove do
    transitions :to => :removed, :from => [:active]
  end
  
  # association statments
  has_many :items, :dependent => :destroy, :order => 'position'
  has_many :images, :dependent => :destroy, :order => 'position'
  
  # validation statements
  validates_presence_of :name
  validates_each :date do |model, attr, value|
    begin
      DateTime.parse(value.to_s)
    rescue
      model.errors.add(attr, "date not valid")
    end
  end
  
  # named scopes
  named_scope :active,  :conditions => {:status => "active"}
  named_scope :drafts,  :conditions => {:status => "draft"}
  named_scope :removed, :conditions => {:status => "removed"}
  
  # overriding to_param method to get prettier urls
  def to_param
    "#{id}-#{name.parameterize.to_s}"
  end
end
