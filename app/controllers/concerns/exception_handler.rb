# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      respond_to do |format|
        format.html
        format.json { json_response({ message: e.message }, :not_found) }
      end
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      respond_to do |format|
        format.html
        format.json { json_response({ message: e.message }, :unprocessable_entity) }
      end
    end
  end
end
