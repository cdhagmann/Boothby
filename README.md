# Boothby

A Rails application lifecycle manager. Boothby provides CLI commands to standardize common development tasks across a team: setting up a fresh clone, updating after pulling new code, and seeding the database.

Named after [Boothby](https://memory-alpha.fandom.com/wiki/Boothby), the groundskeeper of Starfleet Academy.

> **Archived.** This gem is no longer maintained.

## Installation

Add to your application's Gemfile:

```ruby
gem 'boothby'
```

## Usage

### `boothby setup`

Run once after cloning the repo:

```sh
$ boothby setup
```

- Copies any `*.example` config files that don't already have a real counterpart
- Runs `bundle install` and `yarn install` (if `package.json` exists)
- Runs `rails db:prepare db:test:prepare`
- Clears logs and tmp files
- Restarts the application server

### `boothby update`

Run after pulling new code:

```sh
$ boothby update
```

Same as `setup` but runs `db:migrate` instead of `db:prepare`.

### `boothby seed`

Seeds the database using a structured `db/seeds.yml` config:

```sh
$ boothby seed
```

Seeds are organized by environment. A `:base` set runs for all environments; additional sets run only for the matching Rails environment. Progress is shown via animated terminal spinners.

### `Boothby::KeyRing`

Auto-loads all YAML files from `config/` and exposes them as methods with environment-aware access and dot notation:

```ruby
Boothby::KeyRing.database       # reads config/database.yml
Boothby::KeyRing.application    # reads config/application.yml
```

## Configuration

```ruby
# config/initializers/boothby.rb
Boothby.configure do |config|
  config.root                    = Rails.root
  config.seeds_configuration     = 'db/seeds.yml'
  config.configuration_directory = 'config'
end
```

## License

Copyright (c) 2022 Christopher Hagmann. See [MIT License](LICENSE.txt) for further details.
