module SystemLogsHelper
  class Logger < ::Logger
    def self.log_name
      file_name_noext
    end

    def self.file_name_noext
      Rails.env
    end

    def self.file_name
      "#{file_name_noext}.log"
    end

    def self.path
      Rails.root.join('log', file_name)
    end

    def self.read
      return [] unless File.exist?(path)
      file = File::Tail::Logfile.open(path, backward: 2000)
      output = file.read
      file.close
      output.split(/\r?\n/)
    end
  end

  class SidekiqLogger < Logger
    def self.file_name_noext
      'sidekiq'
    end
  end
end
