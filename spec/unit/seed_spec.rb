# frozen_string_literal: true

require 'boothby/commands/seed'

RSpec.describe(Boothby::Commands::Seed) do
  it 'executes `seed` command successfully' do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to(eq("OK\n"))
  end
end
