# frozen_string_literal: true

require 'boothby/commands/update'

RSpec.describe(Boothby::Commands::Update) do
  it 'executes `update` command successfully' do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to(eq("OK\n"))
  end
end
