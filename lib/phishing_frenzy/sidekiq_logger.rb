module PhishingFrenzy
  class SidekiqLogger < Logger
    def self.file_name_noext
      'sidekiq'
    end

    def self.file_name
      "#{file_name_noext}.log"
    end

    def self.read
      path = Rails.root.join('log', file_name)
      return '' unless File.exist?(path)
      File::Tail::Logfile.open(path, backward: 2000)
    end
  end
end
