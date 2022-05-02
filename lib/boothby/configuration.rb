# frozen_string_literal: true

module Boothby
  module Configuration
    extend ActiveSupport::Concern

    included do
      add_config :root
      add_config :seeds_configuration
      add_config :configuration_directory

      # set default values
      reset_config
    end

    module ClassMethods
      def add_config(name)
        class_eval(<<-METHODS, __FILE__, __LINE__ + 1)
          @#{name} = nil
          def self.#{name}(value=nil)
            @#{name} = value if value
            return @#{name} if self.object_id == #{object_id} || defined?(@#{name})
            name = superclass.#{name}
            return nil if name.nil? && !instance_variable_defined?(:@#{name})
            @#{name} = name && !name.is_a?(Module) && !name.is_a?(Symbol) && !name.is_a?(Numeric) && !name.is_a?(TrueClass) && !name.is_a?(FalseClass) ? name.dup : name
          end

          def self.#{name}=(value)
            @#{name} = value
          end

          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            value = @#{name} if instance_variable_defined?(:@#{name})
            value = self.class.#{name} unless instance_variable_defined?(:@#{name})
            if value.instance_of?(Proc)
              value.arity >= 1 ? value.call(self) : value.call
            else
              value
            end
          end
        METHODS
      end

      def configure
        yield(self)
      end

      def reset_config
        configure do |config|
          config.root = -> { Rails.root }
          config.seeds_configuration = 'db/seeds.yml'
          config.configuration_directory = 'config'
        end
      end
    end
  end
end
