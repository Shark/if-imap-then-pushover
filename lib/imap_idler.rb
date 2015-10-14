require_relative 'imap_base'
require_relative 'imap_examiner'

class ImapIdler < ImapBase
  attr_reader :config, :logger, :seen_uids, :message_handler

  def initialize(config, logger, message_handler)
    @config = config
    @logger = logger
    logger.progname = 'ImapIdler'
    @message_handler = message_handler
    @seen_uids = []
  end

  def idle
    begin
      connect unless connection

      loop do
        idle_timeout_thread = Thread.new do
          idle_timeout = config['imap']['idle_timeout']
          logger.debug "Idle timeout set to #{idle_timeout}s"
          sleep idle_timeout

          begin
            connection.idle_done if connection
            logger.info 'End IDLE'
          rescue Net::IMAP::Error => e
            logger.error "Error in end IMAP idle: #{e}"
          end
        end

        mark_messages_seen

        logger.info 'Start IDLE'
        connection.idle do |response|
          if response.kind_of?(Net::IMAP::ContinuationRequest) and response.data.text == 'idling'
            logger.debug 'Receive IMAP continuation request'
          elsif response.kind_of?(Net::IMAP::UntaggedResponse) and response.name == 'EXISTS'
            logger.debug 'Receive event for new message, examine'

            # Run ImapExaminer to check for unread messages
            Thread.new do
              ImapExaminer.new(config, Utils.make_logger, seen_uids.clone, message_handler).examine
            end

            # Stop timeout thread and IDLE
            idle_timeout_thread.exit
            connection.idle_done
            logger.info 'End IDLE'
          end
        end
      end
    ensure
      disconnect if connection
    end
  end

  private

  def mark_messages_seen
    @seen_uids = []
    connection.uid_search('ALL').each do |message_id|
      logger.debug "Mark message_id #{message_id} as seen"
      seen_uids << message_id
    end
  end
end
