# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      respond_to do |format|
        format.html
        # TODO Improve this query
        format.json { render json: e.message, status: :not_found }
      end
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      respond_to do |format|
        format.html
        # TODO Improve this query
        format.json { render json: e.message, status: :unprocessable_entity }
      end
    end
  end
end
