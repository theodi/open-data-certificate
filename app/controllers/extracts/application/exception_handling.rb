module Extracts
  module Application
    module ExceptionHandling
      extend ActiveSupport::Concern

      included do
        unless Rails.application.config.consider_all_requests_local
          rescue_from Exception, :with => :render_error
          rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
          rescue_from ActionController::RoutingError, :with => :render_not_found
          rescue_from ActionController::UnknownController, :with => :render_not_found
          rescue_from ActionController::UnknownAction, :with => :render_not_found
        end
      end

      module InstanceMethods
        def routing_error
          # For catching and re-raising routing errors in the application - see the comment and route appended in application.rb
          raise ActionController::RoutingError.new("No route matches [#{request.method}] \"#{request.fullpath}\"")
        end

        private
        def render_not_found(exception)
          log_error(exception)
          render :template => "/errors/404", :status => 404
        end

        private
        def render_error(exception)
          log_error(exception)
          render :template => "/errors/500", :status => 500
        end

        private
        def log_error(exception)
          # Mostly taken from actionpack-3.2.11/lib/action_dispatch/middleware/debug_exceptions.rb#log_error
          # The "log_error" method in the exception handler is now private, and it was simpler just to paste the salient points here.

          wrapper = ActionDispatch::ExceptionWrapper.new(request.env, exception)

          trace = wrapper.application_trace
          trace = wrapper.framework_trace if trace.empty?
          ActiveSupport::Deprecation.silence do
            message = "\n#{exception.class} (#{exception.message}):\n"
            message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
            message << "  " << trace.join("\n  ")
            logger.fatal("#{message}\n\n")
          end

          # exception_to_db(exception) # Where are we gonna send exceptions... TODO: hook into Airbrake here if desired
        end
      end

    end
  end
end