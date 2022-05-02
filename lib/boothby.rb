# frozen_string_literal: true

require_relative 'boothby/version'
require 'fileutils'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/class/attribute'
require 'active_support/concern'

module Boothby
  class Error < StandardError; end

  class << self
    attr_accessor :root
  end

  def self.configure(&block)
    Boothby::Configuration.configure(&block)
  end
end
