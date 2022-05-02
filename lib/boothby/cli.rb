# frozen_string_literal: true

require 'thor'

module Boothby
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'boothby version'
    def version
      require_relative('version')
      puts("v#{Boothby::VERSION}")
    end
    map %w[--version -v] => :version

    desc 'seed', 'Command description...'
    method_option :help,
                  aliases: '-h',
                  type: :boolean,
                  desc: 'Display usage information'
    def seed(*)
      if options[:help]
        invoke(:help, ['seed'])
      else
        require_relative('commands/seed')
        Boothby::Commands::Seed.new(options).execute
      end
    end

    desc 'update', 'Command description...'
    method_option :help,
                  aliases: '-h',
                  type: :boolean,
                  desc: 'Display usage information'
    def update(*)
      if options[:help]
        invoke(:help, ['update'])
      else
        require_relative('commands/update')
        Boothby::Commands::Update.new(options).execute
      end
    end

    desc 'setup', 'Command description...'
    method_option :help,
                  aliases: '-h',
                  type: :boolean,
                  desc: 'Display usage information'
    def setup(*)
      if options[:help]
        invoke(:help, ['setup'])
      else
        require_relative('commands/setup')
        Boothby::Commands::Setup.new(options).execute
      end
    end
  end
end
