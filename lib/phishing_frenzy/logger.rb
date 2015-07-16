module PhishingFrenzy
  class Logger < ::Logger
    def self.file_name_noext
      Rails.env
    end

    def self.file_name
      "#{file_name_noext}.log"
    end

    def self.read
      path = Rails.root.join('log', file_name)
      return [] unless File.exist?(path)
      file = File::Tail::Logfile.open(path, backward: 2000)
      output = file.read
      file.close
      output.split(/\r?\n/)
    end
  end
end
