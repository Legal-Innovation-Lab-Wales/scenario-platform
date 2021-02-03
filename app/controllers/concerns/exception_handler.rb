# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      respond_to do |format|
        format.html { render file: 'public/404.html', status: :not_found }
        format.json { json_response({ message: e.message }, :not_found) }
      end
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      respond_to do |format|
        format.html { render file: 'public/422.html', status: :unprocessable_entity }
        format.json { json_response({ message: e.message }, :unprocessable_entity) }
      end
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      respond_to do |format|
        format.html { render file: 'public/422.html', status: :unprocessable_entity }
        format.json { json_response({ message: e.message }, :unprocessable_entity) }
      end
    end

    rescue_from ActionController::ParameterMissing do |e|
      respond_to do |format|
        format.html { render file: 'public/422.html', status: :unprocessable_entity }
        format.json { json_response({ message: e.original_message }, :unprocessable_entity) }
      end
    end
  end
end
