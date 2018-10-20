# frozen_string_literal: true

module Response
  extend ActiveSupport::Concern

  def resource_errors(resource)
    resource.errors.to_hash.merge(full_messages: resource.errors.full_messages)
  end

  # def json_response(resource, status_code = :ok)
  #   render json: resource, status: status_code
  # end

  # def success_response(resource, msg, status_code)
  #   render json: [{ status: 'success', message: msg }, resource], status: status_code
  # end

  # def errors_response(resource, status_code)
  #   render json: {status: 'error', errors: resource.errors}, status: status_code
  # end
end
