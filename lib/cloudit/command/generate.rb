require 'cloudit/command/base'

require 'yaml'
require 'json'

class Cloudit::Command::Generate < Cloudit::Command::Base
  VALID_METHODS = ['help']
  SECTIONS = ['Metadata', 'Parameters', 'Mappings', 'Conditions', 'Resources', 'Outputs']

  def index
    if @opts.help?
      $stdout.puts slop_opts
    else
      generate_json
    end
  end

  def invalid_method
    # TODO write method
    help
  end

  private

  def generate_json
    hash = {}
    hash_sections = {}

    for file in Dir.glob(Dir['**/*.cfn.yml']) do
      yml = YAML::load_file(file)
      if yml.is_a?(Hash)
        hash.merge! YAML::load_file(file)
      end
    end

    for section in SECTIONS do
      section_file = section.downcase
      hash_sections[section] = {}

      for file in Dir.glob(Dir["**/*.#{section_file}.yml"]) do
        yml = YAML::load_file(file)

        if yml.is_a?(Hash)
          hash_sections[section].merge! yml
        end
      end
    end

    hash.merge! hash_sections

    $stdout.puts hash.to_json
  end

  def self.setup_options
    opts = Slop::Options.new
    opts.banner = 'Usage: cloudit generate [options]'
    opts.separator ''
    opts.separator 'Generate options:'
    opts.string '-o', '--output', 'a filename', default: 'out.json'
    opts.bool '-h', '--help', 'print options', default: false

    self.slop_opts = opts
    self.parser = Slop::Parser.new(opts)
  end

  setup_options
end
