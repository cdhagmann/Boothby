# frozen_string_literal: true

require 'fileutils'
require 'tty-command'

module Boothby
  class Toolbox
    class << self
      attr_writer :root
    end

    def self.setup_application
      FileUtils.chdir(app_dir) do
        copy_example_files
        install_dependencies
        rake_task('db:prepare', 'db:test:prepare', label: 'Preparing database')
        rake_task('log:clear', 'tmp:clear', label: 'Cleaning old files')
        rake_task('restart', label: 'Restarting application server')
      end
    end

    def self.update_application
      FileUtils.chdir(app_dir) do
        copy_example_files
        install_dependencies
        rake_task('db:migrate', label: 'Updating database')
        rake_task('log:clear', 'tmp:clear', label: 'Cleaning old files')
        rake_task('restart', label: 'Restarting application server')
      end
    end

    def self.upgrade_application
      FileUtils.chdir(app_dir) do
        copy_example_files
        install_dependencies
        rake_task('db:migrate', label: 'Updating database')
        rake_task('log:clear', 'tmp:clear', label: 'Cleaning old files')
        rake_task('restart', label: 'Restarting application server')
      end
    end

    private_class_method def self.install_dependencies
      puts("\n== Installing dependencies ==")
      bundle_install
      yarn_install
    end

    private_class_method def self.yarn_install
      return unless File.exist?('package.json')

      system('command', '-v', 'yarn') || system('npm', 'install', '-g', 'yarn')
      run!(:yarn, :install)
    end

    private_class_method def self.bundle_install
      return unless File.exist?('Gemfile')

      system('bundle', 'check') || run!(:bundle, :install)
    end

    private_class_method def self.copy_example_files
      example_files = Dir['**/*.example*'].filter_map do |example_file|
        real_file = example_file.gsub('.example', '')
        [example_file, real_file] unless File.exist?(real_file)
      end

      return unless example_files.any?

      puts("\n== Copying example files ==")
      example_files.each { |ef, rf| run(:cp, ef, rf) }
    end

    private_class_method def self.rake_task(*args, label:)
      puts("\n== #{label} ==")
      run(:bundle, :exec, :rails, *args)
    end

    private_class_method def self.run(*args, **kwargs)
      kwargs[:only_output_on_error] = true
      cmd.run!(*args, **kwargs)
    end

    private_class_method def self.run!(*args, **kwargs)
      kwargs[:only_output_on_error] = false
      cmd.run!(*args, **kwargs)
    end

    private_class_method def self.cmd
      @cmd ||= TTY::Command.new(
        uuid: false,
        color: true
      )
    end

    private_class_method def self.app_dir
      (@root || File.expand_path('../..', __dir__))
    end
  end
end
