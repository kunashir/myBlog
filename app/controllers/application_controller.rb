#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TransportationsHelper
  #include SimpleCaptcha::ControllerHelpers
  before_filter :authenticate
  #rescue_from Exception, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActionController::UnknownController, with: :render_404


  private
  def authenticate
    unless signed_in?
      flash[:error] = "Для доступа к этому разделу спрева авторизируйтесь!!!"
      redirect_to signin_path
    end
  end

  def render_404(exception)
    #@not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end
end
