class User < ApplicationRecord
  has_secure_password
  has_secure_token #:auth_token

  def self.valid_login?(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end

  def allow_token_to_be_used_only_once_for
    regenerate_token
    touch(:token_created_at)
  end

  def logout
    invalidate_token
  end

  def self.with_unexpired_token(token, date)
    where(token: token).where('token_created_at >= ?', date).first
  end

  private

  def invalidate_token
    self.update_columns(token: nil)
    touch(:token_created_at)
  end
end
