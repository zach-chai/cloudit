require 'cloudit/command/base'

require 'yaml'
require 'json'

class Cloudit::Command::Generate < Cloudit::Command::Base
  VALID_METHODS = ['help']
  SECTIONS = ['Metadata', 'Parameters', 'Mappings', 'Conditions', 'Resources', 'Outputs']
  DESCRIPTION = 'Build YAML files into Cloudformation template'
  DEFAULT_OUT_FILE = 'out.json'
  DEFAULT_MAIN_CFN_EXTENSION = 'cfn.yml'
  DEFAULT_DIRECTORY = './'

  def index
    if @opts.help?
      $stdout.puts slop_opts
    else
      out = @opts[:output]
      dir = normalize_directory @opts[:directory]

      if File.exist? out
        if out.eql? DEFAULT_OUT_FILE
          i = 1
          while File.exist? out
            i += 1
            out = "out#{i}.json"
          end
        else
          $stdout.puts "cloudit: output file '#{out}' already exists"
          return
        end
      end

      json = generate_json(dir)
      File.new(out, 'w').write "#{json}\n"

      $stdout.puts "Template generated to #{out}"
    end
  end

  def generate_json(dir='.')
    hash = {}
    hash_sections = {}

    unless File.directory? dir
      $stdout.puts "cloudit: '#{dir}' must be a directory"
      return
    end

    for file in Dir.glob(Dir["#{dir}**/*.#{DEFAULT_MAIN_CFN_EXTENSION}"]) do
      yml = YAML::load_file(file)
      if yml.is_a?(Hash)
        hash.merge! yml
      end
    end

    for section in SECTIONS do
      section_file = section.downcase
      hash_sections[section] = {}

      for file in Dir.glob(Dir["#{dir}**/*.#{section_file}.yml"]) do
        yml = YAML::load_file(file)

        if yml.is_a?(Hash)
          hash_sections[section].merge! yml
        end
      end
    end

    hash.merge! hash_sections

    hash.to_json
  end

  private

  def normalize_directory(dir)
    if dir.end_with? '/'
      dir
    else
      dir + '/'
    end
  end

  def self.setup_options
    opts = Slop::Options.new
    opts.banner = 'Usage: cloudit generate [options]'
    opts.separator ''
    opts.separator 'Generate options:'
    opts.string '-o', '--output', 'output filename', default: DEFAULT_OUT_FILE
    opts.bool '-h', '--help', 'print options', default: false
    opts.string '-d', '--directory', 'root directory to generate', default: DEFAULT_DIRECTORY

    self.slop_opts = opts
    self.parser = Slop::Parser.new(opts)
  end

  setup_options
end
