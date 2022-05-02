# frozen_string_literal: true

RSpec.describe('`boothby setup` command', type: :cli) do
  it 'executes `boothby help setup` command successfully' do
    output = `boothby help setup`
    expected_output = <<~OUT
      Usage:
        boothby setup

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to(eq(expected_output))
  end
end
