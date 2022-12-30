class ApplicationController < ActionController::Base
  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user
  helper_method :current_user_is_admin

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def current_user_is_admin
    return nil if session[:user_id].nil?

    User.find(session[:user_id]).admin
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'You must be signed in to do that.' if current_user.nil?
  end

  def ensure_user_is_admin
    redirect_to signin_path, notice: 'You must be admin to do that.' unless current_user_is_admin
  end
end
