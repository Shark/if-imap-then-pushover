class Email
  attr_reader :sender, :subject

  def initialize(sender, subject)
    @sender = sender
    @subject = subject
  end
end
