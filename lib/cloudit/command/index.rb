require 'cloudit/version'
require 'cloudit/command/base'

class Cloudit::Command::Index < Cloudit::Command::Base

  def index
    if @opts.version?
      str = "Cloudit version #{Cloudit::VERSION}."
    elsif @opts.help?
      str = usage
    else
      str = usage
    end
    $stdout.puts str
  end

  private

  def usage
    str = slop_opts.to_s
    str += "\nCommands:"
    Cloudit::Command.descriptions.each do |command|
      str += "\n#{command[:command]}  #{command[:description]}"
    end
    str += "\n\nRun 'cloudit COMMAND --help' for more information on a command."
    str
  end

  def self.setup_options
    opts = Slop::Options.new
    opts.banner = 'Usage: cloudit [OPTIONS] COMMAND [ARGS...]'
    opts.separator ''
    opts.separator 'Options:'
    opts.bool '-v', '--version', 'print version', default: false
    opts.bool '-h', '--help', 'print usage', default: false

    self.slop_opts = opts
    self.parser = Slop::Parser.new(opts)
  end

  setup_options
end
