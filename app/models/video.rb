require 'aasm'
class Video < Item
  # state machine modelling
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :converting
  aasm_state :converted, :enter => :set_new_filename
  aasm_state :error
  
  # so we know that we are currently converting the video
  aasm_event :convert do
    transitions :from => :pending, :to => :converting
  end
  
  # so we know the video was succesfully converted
  aasm_event :converted do
    transitions :from => :converting, :to => :converted
  end
  
  # so we know if there was a problem whilst converting the video
  aasm_event :failed do
    transitions :from => :converting, :to => :error
  end
  
  # associations statements
  belongs_to :project
  
  # paperclip attachements
  has_attached_file :source
  
  # paperclip validations, these break the rspec tests
  validates_attachment_presence :source # need to have an attachment
  validates_attachment_content_type :source, :content_type => 'video/quicktime' # only allowing quicktime videos to be uploaded
  validates_attachment_size :source, :less_than => 50.megabytes # images can only be 5MB max
  
  # video conversion methods
  def convert_video
    self.convert!
    success = system(convert_command) # this is where we make the system call to FFMPEG
    if success && $?.exitstatus == 0
      generate_stills
      self.converted!
    else
      self.failed!
    end
  end
  
  def display_thumbnail
    self.source.url(:thumb).gsub!(/video.flv/,"thumb.jpg")
  end
  
  def display_long
    self.source.url(:long).gsub!(/video.flv/,"long.jpg")
  end
  
  protected
  # this method creates the FFMPEG command that converts the video
  def convert_command
    flv = File.join(File.dirname(source.path), "#{id}-video.flv")
    File.open(flv, 'w')
    command = "ffmpeg -i #{source.path} -ar 22050 -ab 32 -acodec mp3 -vcodec flv -r 25 -qscale 8 -f flv -y #{flv}"
    if RAILS_ENV == "development"
      command = "/opt/local/bin/" + command
    end
    logger.debug command
    command.gsub!(/\s+/," ")
  end
  
  def set_new_filename
    update_attribute(:source_file_name, "#{id}-video.flv")
  end
  
  def generate_stills
    if system(still_image_command)
      a = source.path.split("/")
      base_path = a.slice(0, (a.size - 2)).join("/")
      thumb_path = base_path + "/thumb/"
      long_path = base_path + "/long/"
      Paperclip.run thumbnail_command(thumb_path)
      Paperclip.run long_command(long_path)
    end
  end
  
  def still_image_command
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    File.open(still, 'w')
    command = <<-end_command
      ffmpeg -i #{source.path} -an -ss 00:00:01 -an -r 1 -vframes 1 -f mjpeg -y #{still}
    end_command
    logger.debug command
    command.gsub!(/\s+/," ")
  end
    
  # this will generate a thumbnail image of the video
  def thumbnail_command(path)
    FileUtils.mkdir_p path
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    thumb = File.join(path, "#{id}-thumb.jpg")
    File.open(thumb, 'w')
    command = "convert #{still} -thumbnail '100x100^' -gravity center -extent 100x100 #{thumb}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
  
  def long_command(path)
    FileUtils.mkdir_p path
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    long = File.join(path, "#{id}-long.jpg")
    File.open(long, 'w')
    command = "convert #{still} -thumbnail 500x150^ -gravity center -extent 500x150 #{long}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
end
