require 'logger'

class Utils
  def self.make_logger
    Logger.new($stdout).tap do |logger|
      logger.progname = 'if-imap-then-pushover'

      unless %w(development test).include? ENV['RUBY_ENV']
        logger.level = Logger::INFO
      end
    end
  end
end
