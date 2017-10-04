# frozen_string_literal: true

module Decidim
  module Verifications
    module IdDocuments
      # This is an engine that performs an example user authorization.
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::IdDocuments::Admin

        routes do
          resources :id_documents, only: [:edit, :update, :index]

          root to: "id_documents#index"
        end
      end
    end
  end
end
