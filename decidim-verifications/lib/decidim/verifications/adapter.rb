# frozen_string_literal: true

module Decidim
  module Verifications
    autoload :HandlerWrapper, "decidim/verifications/handler_wrapper"
    autoload :WorkflowWrapper, "decidim/verifications/workflow_wrapper"

    class InvalidVerification < StandardError; end

    class Adapter
      def self.from_collection(collection)
        collection.map { |e| wrapper_for(e) }
      end

      def self.from_element(element)
        wrapper_for(element)
      end

      def self.wrapper_for(element)
        manifest = manifest_for(element)
        return WorkflowWrapper.new(manifest) if manifest

        handler = handler_for(element) || handler_for(element.classify)
        return HandlerWrapper.new(handler) if handler

        raise InvalidVerification, "Unknown verification method"
      end

      private_class_method :wrapper_for

      def self.handler_for(element)
        klass = element.constantize
        return unless klass < Decidim::AuthorizationHandler

        klass
      rescue NameError
        nil
      end

      private_class_method :handler_for

      def self.manifest_for(element)
        Verifications.find_workflow_manifest(element)
      end

      private_class_method :manifest_for
    end
  end
end
