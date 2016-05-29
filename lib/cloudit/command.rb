module Cloudit
  module Command

    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        require file
      end
    end

    def self.run(command, args)
      command_instance = Object.const_get(command).new(args)
      command_instance.generate
    end

  end
end
