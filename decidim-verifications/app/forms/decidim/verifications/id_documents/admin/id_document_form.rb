# frozen_string_literal: true

require "digest/md5"

module Decidim
  module Verifications
    module IdDocuments
      module Admin
        # A form object to be used when public users want to get verified by
        # uploading their identity documents.
        class IdDocumentForm < AuthorizationHandler
          DOCUMENT_TYPES = %w(DNI NIE passport).freeze
          VERIFIED_FIELDS = [:document_number, :document_type].freeze

          attribute :document_number, String
          attribute :document_type, String
          attribute :id_document, IdDocument

          validates :document_type,
                    inclusion: { in: DOCUMENT_TYPES },
                    presence: true

          validates :document_number,
                    format: { with: /\A[A-Z0-9]*\z/, message: I18n.t("errors.messages.uppercase_only_letters_numbers") },
                    presence: true

          validate :matching_info

          delegate :user, to: :id_document

          def unique_id
            Digest::MD5.hexdigest(
              "#{document_number}-#{Rails.application.secrets.secret_key_base}"
            )
          end

          def handler_name
            "id_documents"
          end

          def document_types_for_select
            DOCUMENT_TYPES.map do |type|
              [
                I18n.t(type.downcase, scope: "decidim.verifications.id_documents"),
                type
              ]
            end
          end

          def matching_info
            VERIFIED_FIELDS.each do |field|
              unless send(field) == id_document.public_send(field)
                errors.add(field, I18n.t("errors.messages.does_not_match_user_information"))
              end
            end
          end
        end
      end
    end
  end
end
