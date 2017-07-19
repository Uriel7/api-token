class SessionsController < ApiController
  skip_before_action :require_login, only: [:create], raise: false
  #before_action :user_params, only: [:create]

  def create
    if user = User.valid_login?(params[:email], params[:password])
      user.allow_token_to_be_used_only_once_for
      send_auth_token_for_valid_login_of(user)
    else
      render_uanuthorized('Error with your login or password')
    end
  end

  def destroy
    current_user.logout
    head :ok
  end

  private

  # def user_params
  #   params.permit(:email, :password)
  # end

  def send_auth_token_for_valid_login_of(user)
    render json: { token: user.token }
  end
end
