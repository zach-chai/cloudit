module Cloudit
  module Command
    class << self
      attr_accessor :commands, :descriptions
    end

    @commands = []
    @descriptions = []

    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        require file
        com = file.split('/')[-1].chomp('.rb')
        if com == 'index' || com == 'base'
          next
        end
        desc = Object.const_get("Cloudit::Command::#{com.capitalize}::DESCRIPTION")
        self.commands << com
        self.descriptions << {command: com, description: desc}
      end
    end

    def self.run(command, args)
      begin
        if command.nil?
          command = 'index'
        elsif command == 'index'
          raise NameError if command == 'index'
        end
        klass = "Cloudit::Command::#{command.capitalize}"
        instance = Object.const_get(klass).new(args)
      rescue NameError
        $stdout.puts "cloudit: '#{command}' is not a cloudit command.\nSee 'cloudit --help' for usage."
        exit(1)
      end
      instance.execute
    end

    def commands
      self.class.commands
    end

    def descriptions
      self.class.descriptions
    end

  end
end
