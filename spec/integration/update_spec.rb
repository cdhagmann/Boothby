# frozen_string_literal: true

RSpec.describe('`boothby update` command', type: :cli) do
  it 'executes `boothby help update` command successfully' do
    output = `boothby help update`
    expected_output = <<~OUT
      Usage:
        boothby update

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to(eq(expected_output))
  end
end
