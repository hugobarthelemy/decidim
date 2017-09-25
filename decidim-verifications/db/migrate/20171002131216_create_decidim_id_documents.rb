# frozen_string_literal: true

class CreateDecidimIdDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_verifications_id_documents_id_documents do |t|
      t.string :document_type
      t.string :document_number

      t.string :scanned_copy

      t.integer :decidim_user_id, null: false

      t.timestamps
    end
  end
end
