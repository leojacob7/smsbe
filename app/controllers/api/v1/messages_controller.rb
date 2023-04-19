class Api::V1::MessagesController < ApplicationController
  before_action :set_message, only: %i[ show update destroy ]

  # GET /messages
  def index
    @messages = Message.all

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    puts "Creating a new message", message_params
    @message = Message.new(message_params)
    @message.sent_at = message_params[:sent_at]
    @message.user = current_user # set the user to the current user
    puts ">>>>>>", @message.to_s

    if @message.save
      begin
        twilio_service = TwilioService.new
        twilio_service.send_sms(message_params[:phone_number], message_params[:body])

        current_user.messages << @message
        render json: {message: MessageSerializer.new(@message), status: :created}
      rescue => e
        # Handle the exception
        render json: {errors: 'Could not process sms', status: :unprocessable_entity}
      end
      
      # add the message to the associated user's messages array
      
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.where(user_id: params[:userid])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body, :sent_at, :user_id, :phone_number)
    end
end
