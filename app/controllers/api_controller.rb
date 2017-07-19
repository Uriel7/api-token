class ApiController < ApplicationController
  def require_login
    authenticate_token || render_uanuthorized('Access denied')
  end

  def current_user
    @current_user ||= authenticate_token
  end

  #protected

  def render_uanuthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      if user = User.with_unexpired_token(token, 2.days.ago)
        ActiveSupport::SecurityUtils.secure_compare(
                     ::Digest::SHA256.hexdigest(token),
                     ::Digest::SHA256.hexdigest(user.token))
        user
      end
    end
  end
end
