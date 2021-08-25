# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authorized

  # GET /sessions.json
  def index
    if logged_in?
      case session[:login_type]
      when 'P'
        redirect_to patients_home_url
      when 'D'
        redirect_to drivers_home_url
      when 'A'
        redirect_to admins_home_url
      end
    end
  end

  # GET /sessions/new
  def new; end

  # POST /sessions.json
  def create
    type = params[:login_type]

    case @login_type
    when 'p'
      @user = Patient.find_by(email: params[:email])
    when 'v'
      @user = User.where(email: params[:email]).ne(_type: 'Patient').first
    end
    if @user&.authenticate(params[:password])
      session[:user_id] = @user._id
      session[:login_type] = @user._type[0]
    else
      flash.notice = 'Incorrect Email or Password.'
    end
    redirect_to root_url
  end

  # GET /sessions/about
  def about; end

  # GET /sessions/involved
  def involved; end
end
