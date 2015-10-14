require 'pushover'

class PushoverSender
  attr_reader :config, :logger

  def initialize(config, logger)
    @config = config
    @logger = logger
    logger.progname = 'PushoverSender'
  end

  def send(email)
    logger.info('Send Pushover notification')
    Pushover.notification(message: email.subject,
                          title: email.sender,
                          user: config['pushover']['user'],
                          token: config['pushover']['app_token'])
  end
end
