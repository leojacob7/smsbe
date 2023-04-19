class Api::V1::AuthController < ApplicationController
    skip_before_action :require_login, only: [:register, :login, :logout]

    def login
        user = User.find_by(username: register_user_params[:username])
        if user && user.authenticate(register_user_params[:password])
            payload = {user_id: user.id}
            token = encode_token(payload)
            session[:user_id] = user.id
            puts "session>", session[:user_id]
            render json: {user: UserSerializer.new(user), jwt: token}, status: :accepted
        else
            render json: {failure: "Invalid username or password"}, status: :unauthorized
        end

    end

    def register
        user = User.create(register_user_params)
        if user.valid?
        token = encode_token({ user_id: user.id })
        render json: { user: user, jwt: token }
        else
        render json: { errors: user.errors.full_messages, msg: "Failed to register user" }, status: :unprocessable_entity
        end
  end

  def logout
    puts ">>>>>>>>> logout", session[current_user.id], current_user
    session[current_user.id] = nil
    reset_session
    puts ">>>>>>>>>", session
    render json: { message: "Successfully signed out" }, status: :ok
  end



private

    def register_user_params
        
        params.require(:auth).permit(:username, :password, :password_confirmation, :phone_number)
    end

    def login_params
       
        params.require(:user).permit(:username, :password)
    end
end
