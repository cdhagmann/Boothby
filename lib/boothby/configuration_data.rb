# frozen_string_literal: true

module Boothby
  # Specialize hash to allow ease of access for configuration values
  class ConfigurationData
    DEFAULT = 'EMPTY' # Default is to raise KeyError if key does not exist
    ENVIRONMENT = Rails.env.freeze

    def self.from_yaml(filename, **options)
      file_path = Rails.root.join(filename)
      return unless File.file?(file_path)

      content = File.read(file_path)
      content = ERB.new(content).result
      yml = YAML.safe_load(content, [Time, Date], aliases: true)
      new(yml, **options)
    end

    def initialize(hash, **options)
      @options = options.reverse_merge(
        environment: ENVIRONMENT,
        default: DEFAULT
      )

      @hash = add_dot_access(hash.with_indifferent_access)
    end

    def config(first_key = nil, **options)
      return @hash if first_key.blank?

      opts = @options.merge(**options)
      @hash.key?(first_key) ? @hash : @hash.fetch(opts[:environment], @hash)
    end

    def dig(*keys, **options)
      hash = config(keys.first, **options)

      while hash.respond_to?(:fetch) && (key = keys.shift)
        hash = hash.fetch(key, nil)
      end

      keys.empty? ? hash : nil
    end

    def dig!(*keys, **options)
      hash = config(keys.first, **options)

      while hash.respond_to?(:fetch) && (key = keys.shift)
        hash = hash.fetch(key, nil)
      end

      keys.empty? ? hash : raise(KeyError)
    end

    def [](key)
      dig(key)
    end

    def []=(key, value)
      config_hash = @hash.fetch(@options[:environment], @hash)
      config_hash[key] = value
      define_singleton_method(key) { value }
      config_hash.define_singleton_method(key) { value }
    end

    def fetch(key, **options)
      opts = @options.merge(**options)
      hash = config(key, **opts)

      if opts[:default] == DEFAULT
        hash.fetch(key)
      else
        hash.fetch(key, opts[:default])
      end
    end

    def key?(key, **options)
      opts = @options.merge(**options)
      hash = config(key, **opts)
      hash.key?(key)
    end

    def add_dot_access(hash)
      allow_dot_access(hash, base_level: true)
      config_hash = hash.fetch(@options[:environment], hash)
      allow_dot_access(config_hash, base_level: true) if config_hash != hash
      hash
    end

    def allow_dot_access(hash, base_level: true)
      hash.each do |key, value|
        hash.define_singleton_method(key) { value }
        define_singleton_method(key) { value } if base_level
        allow_dot_access(value, base_level: false) if value.is_a?(Hash)
      end
    end
  end
end
