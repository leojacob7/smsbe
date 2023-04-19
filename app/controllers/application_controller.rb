class ApplicationController < ActionController::API
    before_action :require_login
    
    def encode_token(payload)
        JWT.encode(payload, 'my_secret')
    end

    def auth_header
        request.headers['Authorization']
    end
    
    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'my_secret', true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
        
    end

    def current_user
        
        if decoded_token
				
            user_id = decoded_token[0]['user_id']
            # session[user_id] = user_id
            @user = User.find_by(id: user_id)
            
        end
    end
    
    def logged_in?
        puts "Accessing >", params[:userid]
        puts "session >", session[:user_id]
        puts "DAta", current_user.id
        puts "check", current_user.id.to_s == params[:userid].to_s
        !!current_user && current_user.id.to_s == params[:userid].to_s  # ruby object/class instance is 'truthy'
    end
    
    def require_login
        render json: {message: 'Please Login or Sign up to see content'}, status: :unauthorized unless logged_in?
    end
end
