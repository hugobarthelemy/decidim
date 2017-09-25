# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      # This is an engine that performs an example user authorization.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::IdDocuments

        routes do
          resource :id_documents, only: [:new, :create]
          root to: "id_documents#new"
        end
      end
    end
  end
end
