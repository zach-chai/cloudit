require 'yaml'

class Cloudit::Config
  ATTRIBUTES = [:region, :access_key_id, :secret_access_key]

  class << self
    attr_accessor(*ATTRIBUTES)
  end

  yml = YAML::load_file("./.cloudit/config")

  ATTRIBUTES.each do |a|
    self.send("#{a.to_s}=", yml[a.to_s])
  end
end
