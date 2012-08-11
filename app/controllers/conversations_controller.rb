class ConversationsController < ApplicationController
  def index
    # Inbox
    @conversations = current_user.conversations.desc(:updated_at)
    
    # Show first conversation + messages
    @conversation = params[:id] ? Conversation.find_by(id: params[:id]) : @conversations.first
    if @conversation
      @messages = @conversation.messages.asc(:created_at)
      @user = @conversation.partner(current_user)
      
      # Update read status
      @messages.first.add_to_set(:read_by, current_user.id) if @messages.present?
    end
  end
  
  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.asc(:created_at)
    @user = @conversation.partner(current_user)
  end
end
