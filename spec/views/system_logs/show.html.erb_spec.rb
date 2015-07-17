require 'rails_helper'

RSpec.describe "system_logs/show" do

  it "should have tab and list elements" do
    render

    expect(rendered).to match /data-toggle/
    expect(rendered).to match /<ol>/
    expect(rendered).to match /<li>/
  end

  it "should have an active tab" do
    render

    expect(rendered).to match /active/
  end

  it "displays environment log" do
    env_log = Rails.env.to_s

    render

    expect(rendered).to match /#{env_log}/
  end

  it "displays sidekiq log" do
    render

    expect(rendered).to match /sidekiq/
  end
end
