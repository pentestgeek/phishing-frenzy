module PhishingFrenzy
  class SidekiqLogger < Logger
    def self.file_name_noext
      'sidekiq'
    end
  end
end
