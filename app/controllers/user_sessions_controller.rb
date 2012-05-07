class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to auth_complete_path(:html)
    else
      @user = User.new
      render 'serviceexecution/startup/index', :layout => 'serviceexecution/startup'
    end
  end

  #---------------ANDROID--------------
  def create_android
    login = params[:login]
    password = params[:password]

    @user_session = UserSession.new(:login => login, :password => password)
    if @user_session.save
      redirect_to auth_complete_path(:json)
    else
      render :text => "false"
    end
  end
  #---------------ANDROID--------------

  def logout
    current_user_session.destroy
    redirect_to :index
  end
end
