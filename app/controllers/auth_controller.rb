class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: []

  def index
    # Renders the auth page which contains both login and registration panels
  end
end
