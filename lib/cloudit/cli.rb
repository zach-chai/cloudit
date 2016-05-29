module Cloudit
  class CLI

    def self.start(*args)
      $stdin.sync = true if $stdin.isatty
      $stdout.sync = true if $stdout.isatty

      command = args.shift.strip rescue "help"
      
      $stdout.puts command
    end
  end
end