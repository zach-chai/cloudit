module Cloudit
  module Command

    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        require file
      end
    end

    def self.run(command, args)
      klass = "Cloudit::Command::#{command.capitalize}"
      instance = Object.const_get(klass).new(args)
      instance.execute
    end

  end
end
