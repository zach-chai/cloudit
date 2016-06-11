require 'cloudit/command/base'
require 'cloudit/command/generate'
require 'aws-sdk'

class Cloudit::Command::Validate < Cloudit::Command::Base
  VALID_METHODS = ['help']
  DESCRIPTION = "Validate CloudFormation template"

  def index
    if @opts.help?
      $stdout.puts slop_opts
    else
      validate_template
    end
  end

  private

  def validate_template(region='us-east-1')
    cf = Aws::CloudFormation::Client.new(
      region: region,
      access_key_id: Cloudit::Config.access_key_id,
      secret_access_key: Cloudit::Config.secret_access_key
    )

    json = Cloudit::Command::Generate.new.generate_json
    resp = cf.validate_template(template_body: json)
    $stdout.puts resp
  rescue Aws::CloudFormation::Errors::ValidationError => e
    $stdout.puts e.message
  end

  def self.setup_options
    opts = Slop::Options.new
    opts.banner = 'Usage: cloudit validate'
    opts.separator ''
    opts.separator 'Validate options:'
    opts.bool '-h', '--help', 'print usage', default: false

    self.slop_opts = opts
    self.parser = Slop::Parser.new(opts)
  end

  setup_options
end
