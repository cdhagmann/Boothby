# frozen_string_literal: true

RSpec.describe('`boothby seed` command', type: :cli) do
  it 'executes `boothby help seed` command successfully' do
    output = `boothby help seed`
    expected_output = <<~OUT
      Usage:
        boothby seed

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to(eq(expected_output))
  end
end
