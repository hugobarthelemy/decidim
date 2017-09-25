# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      #
      # Handles verification by identity document upload
      #
      class IdDocumentsController < Decidim::ApplicationController
        skip_authorization_check

        def new
          @form = IdDocumentForm.from_params(
            attachment: AttachmentForm.from_params({})
          )
        end

        def create
          @form = IdDocumentForm.from_params(params)

          CreateIdDocument.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = t("id_documents.create.success", scope: "decidim.verifications.id_documents")
              redirect_to decidim.authorizations_path
            end

            on(:invalid) do
              flash[:alert] = t("id_documents.create.error", scope: "decidim.verifications.id_documents")
              render action: :new
            end
          end
        end
      end
    end
  end
end
