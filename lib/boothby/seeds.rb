# frozen_string_literal: true

require 'tty-spinner'

module Boothby
  class Plant
    class << self
      attr_writer :root, :config_file, :rails_env
    end

    def self.seed!
      require_seed_modules!

      seed(environment: :base)
      seed(environment: rails_env)
    end

    private_class_method def self.seed(environment:)
      label = environment == :base ? 'ALL ENVIRONMENTS' : environment.to_s.upcase
      env_class = environment.to_s.classify
      multi_spinner = TTY::Spinner::Multi.new(
        "[:spinner] SEEDING MODELS FOR #{label}",
        hide_cursor: true,
        success_mark: pastel.green('✓'),
        error_mark: pastel.red('×'),
        interval: 5,
        format: :arc,
        style: {
          top: ' ',
          middle: '   ',
          bottom: '   '
        }
      )

      config(environment).each do |seed_class|
        seed_from(seed_class)
      end
      multi_spinner.auto_spin
    end

    private_class_method def self.root(*args)
      @root ||= File.expand_path('../..', __dir__)
      File.join(@root, *args)
    end

    private_class_method def self.rails_env
      (@rails_env || 'development').to_sym
    end

    private_class_method def self.seeds_available?(*path)
      Dir[root(:db, :seeds, *path, '*.rb"')].count > 0
    end

    private_class_method def self.config_file
      (@config_file || root('db/seeds.yml'))
    end

    private_class_method def self.require_modules(*path)
      Dir[root(:db, :seeds, *path, '*.rb"')].sort.each { |s| require(s) }
    end

    private_class_method def self.config
      @config ||= begin
        content = File.read(config_file)
        yml = YAML.safe_load(content, [Time, Date], aliases: true)
        yml.with_indifferent_access
      end
    end

    def self.seed_from(seed_class)
      multi_spinner.register(
        '[:spinner] :title',
        hide_cursor: true,
        success_mark: pastel.green('✓'),
        error_mark: pastel.red('×'),
        interval: 5,
        format: :arc
      ) do |spinner|
        title = seed_method[4..-1].titleize
        spinner.update(title: "Seeding #{title}")
        seed_class.public_send(seed_method)
        spinner.update(title: "Seeded #{title}")
        spinner.success
      end
    end

    def self.seed_methods(seed_class)
      methods = seed_class.methods.map(&:to_s).select do |method|
        method.starts_with?('seed_')
      end
      methods.sort_by { |method| seed_class.method(method).source_location.last }
    end
  end
end

# :nodoc:
module Seeds
  # rubocop:disable Style/OpenStructUse
  def self.departments
    [
      Department.master_department,
      Department.executive_health,
      Department.signature_care,
      OpenStruct.new(name: 'General', key: 'general')
    ]
  end
  # rubocop:enable Style/OpenStructUse

  def self.sprout
    return if Rails.env.test?

    require_seed_modules!

    seed_by_departments(environment: :base)
    seed_by_departments(environment: Rails.env.to_sym)
  end

  def self.seed(environment:)
    label = environment == :base ? 'ALL ENVIRONMENTS' : environment.to_s.upcase
    env_class = environment.to_s.classify
    multi_spinner = TTY::Spinner::Multi.new(
      "[:spinner] SEEDING MODELS FOR #{label}",
      hide_cursor: true,
      success_mark: pastel.green('✓'),
      error_mark: pastel.red('×'),
      interval: 5,
      format: :arc
    )

    departments.each do |department|
      next unless seeds_available?(environment, department)

      seed_class = "Seeds::#{env_class}::#{department.key.classify}".constantize

      display(department.name.upcase, indent: 1)
      seed_from(seed_class, department: department)
    end
  end

  def self.require_seed_modules!
    Dir[Rails.root.join('db/seeds/**/*.rb')].sort.each { |s| require(s) }
  end

  def self.seed_from(seed_class, department:)
    seed_methods(seed_class).each do |seed_method|
      title = seed_method[4..-1].titleize
      display("Seeding #{title}...\n", indent: 2)
      seed_class.public_send(seed_method, department)
      display("Seeded: #{title}\n", indent: 2)
    end
  end

  def self.seed_methods(seed_class)
    methods = seed_class.methods.map(&:to_s).select do |method|
      method.starts_with?('seed_')
    end
    methods.sort_by { |method| seed_class.method(method).source_location.last }
  end

  def self.display(text, indent: 0, header: false)
    text = "\n======  #{text}" if header
    text = "#{'  ' * indent}- #{text}" if indent > 0

    puts(text)
  end

  def self.seeds_available?(environment, department)
    seed_path = "db/seeds/#{environment}/#{department.key}/*.rb"
    Dir[Rails.root.join(seed_path)].count > 0
  end
end

Seeds.sprout
