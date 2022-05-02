# frozen_string_literal: true

module Boothby
  # Read YAML files
  class YAMLReader
    attr_reader :filename

    def initialize(name)
      @filename = file_name(name)
    end

    def get(*attributes, environment: nil)
      environment ||= Rails.env
      full_config[environment].dig(*attributes) || full_config.dig(*attributes)
    end

    def method_missing(method_name, *args, **kwargs, &block)
      env = kwargs.delete(:environment) || kwargs.delete(:env)
      return get(method_name, environment: env) unless env.nil?

      cfg = full_config.fetch(method_name, nil)
      return (args.empty? ? cfg : cfg.dig(*args)) unless cfg.nil?

      get(method_name) || super
    end

    private def full_config
      return unless config_exist?

      @full_config ||= begin
        content = File.read(@filename)
        content = ERB.new(content).result if erb_file?
        yml = YAML.safe_load(content, [Time, Date], aliases: true)
        yml.with_indifferent_access
      end
    end

    private def config_exist?
      @filename.present?
    end

    private def erb_file?
      @filename.to_s.ends_with?('.erb')
    end

    private def file_name(name)
      return name if yml_file?(name) && absolute_path?(name)
      return Rails.root.join(name) if yml_file?(name)

      name = Rails.root.join("config/#{name.to_s.downcase.underscore}").to_s unless absolute_path?(name)

      find_file(name)
    end

    private def possible_file_extensions
      %w[yml yaml yml.erb yaml.erb]
    end

    private def yml_file?(file)
      extension(file).in?(possible_file_extensions)
    end

    private def extension(file)
      File.basename(file.to_s).split('.').drop(1).try(:join, '.')
    end

    private def absolute_path?(file)
      file.start_with?(Rails.root.to_s)
    end

    private def find_file(prefix)
      possible_file_extensions.map { |ext| "#{prefix}.#{ext}" }.find do |file|
        File.exist?(file)
      end
    end
  end
end
