class SessionsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  def login
    @session = Session.new
  end

  def create
    @user = Session.find_by user:session_params[:user]

    if @user && @user.password == session_params[:password]
      reset_session
      session[:user] = @user.user

      respond_to do |format|
        format.html { redirect_to root_url, notice: 'login successed.' }
        format.json { head :no_content }
      end      
    else
      respond_to do |format|
        format.html { redirect_to sessions_login_url, notice: 'login failed.' }
        format.json { head :no_content }
      end
    end
  end

  def logout
    session.clear
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'bye bye.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
      params.require(:session).permit(:user, :password)
  end
end
