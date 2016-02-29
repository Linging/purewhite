require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
	end

 	test "valid signup information" do 
 		get signup_path
 		name = "Example User"
 		email = "user@example.com"
 		password = "password"
 		assert_difference 'User.count' , 1 do
 			post_via_redirect users_path, user: { name:name,
 		                                                                    email:email,
 		                    				       			password:password,
 							       				password_confirmation:password}

 		end
 		#assert_template 'users/new'
 		#assert_select 'div#error_explanation'  //Failed assertion, no message given
 		#assert_select 'div.field_with_errors'
 	end

 	test "valid signup information with account activation" do
 		get signup_path
 		assert_difference 'User.count', 1 do
 			post users_path, user: {  name: "Example User",
 									email: "user@example.com",
 									password: "password",
 									password_confirmation: "password"}
 		end
 		assert_equal 1, ActionMailer::Base.deliveries.size
 		user = assigns(:user)
 		assert_not user.activated?
 		#try login before activated
 		log_in_as(user)
 		assert_not is_logged_in?
 		#invalid activation token
 		get edit_account_activation_path("invalid token")
 		assert_not is_logged_in?
 		#valid activation while wrong email address
 		get edit_account_activation_path(user.activation_token, email: 'wrong')
 		assert_not is_logged_in?
 		#valid token
 		get edit_account_activation_path(user.activation_token, email: user.email)
 		assert user.reload.activated?
 		follow_redirect!
 		#assert_template 'user/show'
 		assert is_logged_in?
 	end
end