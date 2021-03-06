# frozen_string_literal: true

module Boothby
  class Base
    include Boothby::Configuration

    def self.root(*args)
      @root ||= File.expand_path('../..', __dir__)
      File.join(@root, *args)
    end
  end
end
