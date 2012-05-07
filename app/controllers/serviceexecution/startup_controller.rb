class Serviceexecution::StartupController < ApplicationController
  def index

    unless current_user
      @user = User.new
      @user_session = UserSession.new
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end
end
