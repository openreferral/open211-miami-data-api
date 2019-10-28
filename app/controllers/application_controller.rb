class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate_api_key!
    authenticate_with_http_token do |token, options|
      @api_account = ApiAccount.find_by(api_key: token)
    end

    render json: { error: "Not authorized" }, status: 401 unless @api_account
  end
end
