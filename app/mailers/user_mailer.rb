class UserMailer < ActionMailer::Base
  default from: "\"[ thirdplace ]\" <conversations@athirdplace.com>"
  def start_conversation(sender, recipient, community)
    @sender = sender
    @recipient = recipient
    @community = community
  
    mail from: "#{@community.display_name}", to: @recipient.email, subject: "#{@sender.first_name} has started a conversation with you."
  end  
end
