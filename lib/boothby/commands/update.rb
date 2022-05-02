# frozen_string_literal: true

require_relative '../command'
require_relative '../app'

module Boothby
  module Commands
    class Update < Boothby::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        Boothby::App.update
      end
    end
  end
end
