class MessagesController < ApplicationController
  def new
    @user = User.find_by(id: params[:id])
  end
  def create
    @message = Message.new(params[:message])
    
    if params[:message][:conversation_id]
      @message.conversation = Conversation.find_by(id: params[:message][:conversation_id])
    else
      @message.conversation = Conversation.create!(user_ids: [ current_user.id, params[:message][:recipient_id] ])
    end
    
    @message.user = current_user
    @message.push(:read_by, current_user.id)
    
    if @message.save!
      @message.conversation.touch
      
      # Send reminder email
      @recipient = @message.conversation.partner(current_user)
      if @message.conversation.messages.length == 1
        UserMailer.delay.conversation_email(current_user, @recipient, @community, :start)
      else
        #DateTime.now.end_of_day + 4.hours
        Rufus::Scheduler.start_new.at "#{DateTime.now + 2.minutes}" do
          if @message.conversation.has_unread_by(@recipient)
            UserMailer.conversation_email(current_user, @recipient, @community, :continue).deliver
          end
        end
      end
      
      respond_to do |format|
        format.html { redirect_to conversations_path }
        format.js
      end
    end
  end
end
