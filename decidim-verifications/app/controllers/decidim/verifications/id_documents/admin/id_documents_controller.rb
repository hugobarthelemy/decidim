# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      module Admin
        class IdDocumentsController < Decidim::Admin::ApplicationController
          layout "decidim/admin/users"

          skip_authorization_check

          def index
            @id_documents = IdDocument.all
          end

          def edit
            id_document = IdDocument.find(params[:id])

            @form = Admin::IdDocumentForm.new(id_document: id_document)
          end

          def update
            id_document = IdDocument.find(params[:id])

            @form = Admin::IdDocumentForm.new(
              id_document: id_document,
              document_type: params[:id_document][:document_type],
              document_number: params[:id_document][:document_number]
            )

            VerifyIdDocument.call(@form) do
              on(:ok) do
                flash[:notice] = t("id_documents.update.success", scope: "decidim.verifications.id_documents.admin")
                redirect_to id_documents_path
              end

              on(:invalid) do
                flash[:alert] = t("id_documents.update.error", scope: "decidim.verifications.id_documents.admin")
                render :edit
              end
            end
          end
        end
      end
    end
  end
end
