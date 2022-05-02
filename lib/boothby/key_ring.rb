# frozen_string_literal: true

require 'singleton'
require_relative 'yaml_reader'

# Store configuration YAML files
module Boothby
  class KeyRing
    include Singleton

    def initialize
      config_files = Dir[Rails.root.join('config/*.y{a,}ml{.erb,}')]
      @configs = config_files.to_h do |config|
        config_name = File.basename(config).split('.').first.to_sym
        [config_name, Boothby::YAMLReader.new(config)]
      end
    end

    def self.method_missing(method_name, *arguments, **kwargs, &block)
      if instance.respond_to?(method_name)
        instance.public_send(method_name)
      else
        super
      end
    end

    def self.respond_to_missing?(method_name, include_private = false)
      instance.respond_to?(method_name) || super
    end

    def method_missing(method_name, *arguments, **kwargs, &block)
      if @configs.key?(method_name.to_sym)
        @configs[method_name.to_sym]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @configs.key?(method_name.to_sym) || super
    end
  end
end
