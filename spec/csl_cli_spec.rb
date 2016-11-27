require "spec_helper"
require 'csl_cli'

describe CslCli do
  it "has a version number" do
    expect(CslCli::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
