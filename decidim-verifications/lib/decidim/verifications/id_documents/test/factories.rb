# frozen_string_literal: true

require "decidim/dev"

FactoryGirl.define do
  factory :id_document, class: Decidim::Verifications::IdDocuments::IdDocument do
    document_type "DNI"
    document_number "XXXXXXXX-Y"
    scanned_copy { Decidim::Dev.test_file("id.jpg", "image/jpeg") }

    user
  end
end
