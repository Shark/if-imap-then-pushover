require 'net/imap'

class ImapBase
  protected

  attr_reader :connection

  def connect
    logger.debug 'Open IMAP connection'
    @connection = Net::IMAP.new config['imap']['hostname'], config['imap']['port'], ssl: true
    connection.login config['imap']['username'], config['imap']['password']
    logger.debug 'Connection open'

    # Ensure that the server supports IDLE
    raise 'server does not support IDLE' if !connection.capability.include? 'IDLE'

    logger.debug "Open folder #{config['imap']['folder']}"
    connection.examine config['imap']['folder']
  end

  def disconnect
    logger.info 'Log out'
    connection.logout
    logger.info 'Disconnect'
    connection.disconnect
    @connection = nil
  end
end
