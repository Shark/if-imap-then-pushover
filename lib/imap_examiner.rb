require 'mail'
require_relative 'imap_base'
require_relative 'email'

class ImapExaminer < ImapBase
  attr_reader :config, :logger, :seen_uids, :message_handler

  def initialize(config, logger, seen_uids, message_handler)
    @config = config
    @logger = logger
    logger.progname = 'ImapExaminer'
    @seen_uids = seen_uids
    @message_handler = message_handler
  end

  def examine
    begin
      connect unless connection
      examine_messages(&message_handler)
    ensure
      disconnect if connection
    end
  end

  private

  def examine_messages
    messages = connection.uid_search(['UNSEEN'])
    logger.debug "Examine #{messages.count} messages"
    examined_message_ids = []
    messages.each do |message_id|
      if seen_uids.include? message_id
        logger.debug "Skip message_id #{message_id} because it has been seen"
        next
      end

      logger.debug "Examine message_id #{message_id}"
      email = examine_message connection.uid_fetch(message_id, ['ENVELOPE', 'RFC822'])[0]
      logger.debug "Received message from #{email.sender} with subject #{email.subject}"
      yield email
      examined_message_ids << message_id
    end

    return examined_message_ids
  end

  def examine_message(message)
    envelope = message.attr['ENVELOPE']
    mail = Mail.read_from_string(message.attr['RFC822'])

    sender = envelope.from[0].mailbox + '@' + envelope.from[0].host
    subject = mail.subject

    return Email.new(sender, subject)
  end
end
