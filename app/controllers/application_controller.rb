class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TransportationsHelper
  #layout "app"
  #include SimpleCaptcha::ControllerHelpers
end
