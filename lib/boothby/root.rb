# frozen_string_literal: true

module Boothby
  class Root
    include Boothby::Configuration

    def self.join(*args)
      @root ||= File.expand_path('../..', __dir__)
      File.join(@root, *args)
    end
  end
end
