# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      # A command to authorize a user with an authorization form.
      class CreateIdDocument < Rectify::Command
        # Public: Initializes the command.
        #
        # form - An IdDocumentForm object.
        # current_user - The current user.
        def initialize(form, current_user)
          @form = form
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) unless form.valid?

          create_id_document
          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_id_document
          id_document = IdDocument.find_or_initialize_by(
            document_type: form.document_type,
            document_number: form.document_number,
            user: @current_user
          )

          id_document.update!(scanned_copy: form.scanned_copy)
        end
      end
    end
  end
end
