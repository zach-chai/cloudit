require 'cloudit/command/base'
require 'cloudit/command/generate'
require 'aws-sdk'

class Cloudit::Command::Validate < Cloudit::Command::Base
  VALID_METHODS = ['help']
  DESCRIPTION = "Validate CloudFormation template"
  DEFAULT_REGION = 'us-east-1'

  def index
    if @opts.help?
      $stdout.puts slop_opts
    else
      validate_template @opts[:region]
    end
  end

  private

  def validate_template(region=DEFAULT_REGION)
    cf = Aws::CloudFormation::Client.new(
      region: region,
      access_key_id: Cloudit::Config.access_key_id,
      secret_access_key: Cloudit::Config.secret_access_key
    )

    json = Cloudit::Command::Generate.new.generate_json @opts[:directory]
    resp = cf.validate_template(template_body: json)
    $stdout.puts "Template is valid"
  rescue Aws::CloudFormation::Errors::ValidationError => e
    $stdout.puts e.message
  end

  def self.setup_options
    opts = Slop::Options.new
    opts.banner = 'Usage: cloudit validate'
    opts.separator ''
    opts.separator 'Validate options:'
    opts.string '-r', '--region', 'region used for validation', default: Cloudit::Config.region || DEFAULT_REGION
    opts.string '-d', '--directory', 'root directory to generate', default: DEFAULT_DIRECTORY
    opts.bool '-h', '--help', 'print usage', default: false

    self.slop_opts = opts
    self.parser = Slop::Parser.new(opts)
  end

  setup_options
end
