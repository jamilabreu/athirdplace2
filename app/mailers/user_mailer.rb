class UserMailer < ActionMailer::Base
  default from: "\"[ thirdplace ]\" <conversations@athirdplace.com>"
  
  def conversation_email(sender, recipient, community, type)
    @sender = sender
    @recipient = recipient
    @community = community
    @type = type
  
    mail from: "#{@community.display_name}", to: @recipient.email, subject: "#{@sender.first_name} has #{type == :start ? 'started' : 'continued'} a conversation with you."
  end 
end
