require 'yaml'
require 'json'

module Cloudit
  class Core
    SECTIONS = ['Metadata', 'Parameters', 'Mappings', 'Conditions', 'Resources', 'Outputs']

    def generate
      hash = {}
      hash_sections = {}

      for file in Dir.glob(Dir["**/*.cfn.yml"]) do
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

      puts hash.to_json
    end
  end
end
