# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      module Admin
        # A command to verify a given identity document.
        class VerifyIdDocument < Decidim::AuthorizeUser
          private

          def create_authorization
            handler.id_document.destroy

            super
          end
        end
      end
    end
  end
end
