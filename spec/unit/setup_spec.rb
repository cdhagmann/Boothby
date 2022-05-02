# frozen_string_literal: true

require 'boothby/commands/setup'

RSpec.describe(Boothby::Commands::Setup) do
  it 'executes `setup` command successfully' do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to(eq("OK\n"))
  end
end
