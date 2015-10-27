require 'rails_helper'

describe SystemLogsHelper do
  describe 'logger' do
    describe ".log_name" do
      it "returns a log name equalling the rails environment" do
        expect(subject::Logger.log_name).to eql(Rails.env)
      end
    end

    describe ".file_name_noext" do
      it "returns a file name without extension equalling the rails environment" do
        expect(subject::Logger.file_name_noext).to eql(Rails.env)
      end
    end

    describe ".file_name" do
      it "returns a file name including the .log extension" do
        expect(subject::Logger.file_name).to end_with('.log')
      end
    end

    describe ".path" do
      it "returns a full path to the file" do
        path = subject::Logger.path.to_s
        expect(path).to end_with('.log')
        expect(path).to start_with(Rails.root.to_s)
      end
    end
  end

  describe 'sidekiq' do
    describe ".file_name_noext" do
      it "returns a file name without extension equalling the rails environment" do
        expect(subject::SidekiqLogger.file_name_noext).to eql('sidekiq')
      end
    end

  end
end
