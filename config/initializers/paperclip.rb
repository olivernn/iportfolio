if RAILS_ENV == "production"
  Paperclip.options[:command_path] = "/usr/local/bin/"
else
  Paperclip.options[:command_path] = "/opt/local/bin/"
end