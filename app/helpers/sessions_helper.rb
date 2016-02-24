module SessionsHelper
	#Log in user Account
	def log_in(user)
		session[:user_id] = user.id
	end
	#remember user in lasting session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end
	#return user which cookie correspondings 
	def current_user
	       if (user_id = session[:user_id])
      			@current_user ||= User.find_by(id: user_id)
              elsif (user_id = cookies.signed[:user_id])
      			user = User.find_by(id: user_id)
      		    	if user && user.authenticated?(cookies[:remember_token])
        			log_in user
        			@current_user = user
		       end
    	       end
    	end
	
	#logged => ture else => false
	def logged_in?
		!current_user.nil?
	end
	#forget lasting Sessions
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	#log out user logging
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil	
	end
end
