# frozen_string_literal: true

require_relative '../command'
require_relative '../app'

module Boothby
  module Commands
    class Setup < Boothby::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        Boothby::App.setup
      end
    end
  end
end
