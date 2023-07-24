class ApplicationController < ActionController::API

    SECRET_KEY = Rails.application.secrets.secret_key_base. to_s
    EXPIRATION_TIME=30.minutes

    def authentication
        
        # making a request to a secure route, token must be included in the headers
        decode_data = decode_user_data(request.headers["token"])
    
        # getting user id from a nested JSON in an array.
        user_data = decode_data[0]["user_data"] unless !decode_data
        
        #puts user_data
        # find a user in the database to be sure token is for a real user
        user = User.find(user_data)
    
        # The barebone of this is to return true or false, as a middleware
        # its main purpose is to grant access or return an error to the user
    
        if user
          return true
        else
          render json: { message: "Invalid credentials" }
        end
      end

     # turn user data (payload) to an encrypted string  [ A ]
    def encode_user_data(payload)
        payload[:exp] = EXPIRATION_TIME.from_now.to_i
        token = JWT.encode payload, SECRET_KEY, "HS256"
        return token
    end

    # turn user data (payload) to an encrypted string  [ B ]
    # def encode_user_data(payload)
    #     payload[:exp] = EXPIRATION_TIME.from_now.to_i
    #     JWT.encode payload, SECRET_KEY, "HS256"
    # end

     #decode token and return user info, this returns an array, [payload and algorithms] [ A ]
    def decode_user_data(token)
        begin
        data = JWT.decode token, SECRET_KEY, true, { algorithm: "HS256" }
        return data
        rescue => e
        puts e
        end
    end

    # decode token and return user info, this returns an array, [payload and algorithms] [ B ]
    # def decode_user_data(token)
    #     begin
    #     JWT.decode token, SECRET_KEY, true, { algorithm: "HS256" }
    #     rescue => e
    #     puts e
    #     end
    # end



end
