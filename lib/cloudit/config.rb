require 'yaml'

class Cloudit::Config
  ATTRIBUTES = [:region, :access_key_id, :secret_access_key]
  FILE_NAME = "./.cloudit/config"

  class << self
    attr_accessor(*ATTRIBUTES)
  end

  yml = if File.exist? FILE_NAME
    YAML::load_file(FILE_NAME)
  else
    {}
  end

  ATTRIBUTES.each do |a|
    self.send("#{a.to_s}=", yml[a.to_s])
  end
end
