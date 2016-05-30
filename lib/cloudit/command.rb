module Cloudit
  module Command
    class << self
      attr_accessor :commands
    end

    @commands = []

    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        self.commands << file.split('/')[-1].chomp('.rb')
        require file
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

  end
end
