class AuthenticateController < ApplicationController

	enable :sessions
	set :protection, :except => :frame_options

	$oauth_creds = {"test" => "secret", "testing" => "supersecret"}

	def show_error(message)
	  @message = message
	  erb :error
	end	

	def authorize!
	  if key = params['oauth_consumer_key']
	    if secret = $oauth_creds[key]
	      @tp = IMS::LTI::ToolProvider.new(key, secret, params)
	    else
	      @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
	      @tp.lti_msg = "Your consumer didn't use a recognized key."
	      @tp.lti_errorlog = "You did it wrong!"
	      return show_error "Consumer key wasn't recognized"
	    end
	  else
	    return show_error "No consumer key"
	  end

	  if !@tp.valid_request?(request)
	    return show_error "The OAuth signature was invalid"
	  end

	  if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
	    return show_error "Your request is too old."
	  end

	  # this isn't actually checking anything like it should, just want people
	  # implementing real tools to be aware they need to check the nonce
	  if was_nonce_used_in_last_x_minutes?(@tp.request_oauth_nonce, 60)
	    return show_error "Why are you reusing the nonce?"
	  end

	  # save the launch parameters for use in later request
	  session['launch_params'] = @tp.to_params

	  @username = @tp.username("Dude")
	end

  def login
	  authorize!

	  if @tp.outcome_service?
	    # It's a launch for grading
	    erb :assessment
	  else
	    # normal tool launch without grade write-back
	    @tp.lti_msg = "Sorry that tool was so boring"
	    erb :boring_tool
	  end  	
  end
end
