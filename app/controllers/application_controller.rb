class ApplicationController < ActionController::Base
  protect_from_forgery
  http_basic_authenticate_with :name => "welaika", :password => "5baa61e4"
end
