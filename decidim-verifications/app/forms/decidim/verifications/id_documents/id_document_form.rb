# frozen_string_literal: true

require "digest/md5"

module Decidim
  module Verifications
    module IdDocuments
      # A form object to be used when public users want to get verified by
      # uploading their identity documents.
      class IdDocumentForm < Decidim::Form
        DOCUMENT_TYPES = %w(DNI NIE passport).freeze

        mimic :id_document

        attribute :document_number, String
        attribute :document_type, String
        attribute :scanned_copy

        validates :document_type,
                  inclusion: { in: DOCUMENT_TYPES },
                  presence: true

        validates :document_number,
                  format: { with: /\A[A-Z0-9]*\z/, message: I18n.t("errors.messages.uppercase_only_letters_numbers") },
                  presence: true

        validates :scanned_copy,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] },
                  presence: true

        delegate :document_types, to: :class

        def document_types_for_select
          DOCUMENT_TYPES.map do |type|
            [
              I18n.t(type.downcase, scope: "decidim.verifications.id_documents"),
              type
            ]
          end
        end
      end
    end
  end
end
