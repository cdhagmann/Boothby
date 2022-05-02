# frozen_string_literal: true

require_relative '../command'
require_relative '../app'

module Boothby
  module Commands
    class Seed < Boothby::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        Boothby::Seed.seed!
      end
    end
  end
end
