# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      #
      # Holds an identity document associated to a decidim user
      #
      class IdDocument < ApplicationRecord
        mount_uploader :scanned_copy, IdDocumentUploader

        belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
      end
    end
  end
end
