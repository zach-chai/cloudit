require 'cloudit/version'
require 'cloudit/command/base'

require 'byebug'

class Cloudit::Command::Index < Cloudit::Command::Base
  class << self
    attr_accessor :usage
  end

  def usage
    self.class.usage
  end

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

  def self.build_usage
    str = slop_opts.to_s
    Cloudit::Command.commands.each do |command|
      str += command
    end
    self.usage = str
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
  build_usage
end
