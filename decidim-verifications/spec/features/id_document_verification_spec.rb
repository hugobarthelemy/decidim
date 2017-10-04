# frozen_string_literal: true

require "spec_helper"

describe "Identity document verification", type: :feature do
  let!(:organization) do
    create(:organization, available_authorizations: ["id_documents"])
  end

  let!(:user) { create(:user, :confirmed, organization: organization) }
  let!(:admin) { create(:user, :confirmed, :admin, organization: organization) }

  let!(:id_document) do
    create(:id_document, document_type: "DNI", document_number: "XXXXXXXXY")
  end

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin_id_documents.root_path
  end

  it "shows the list of pending verifications" do
    expect(page).to have_link("Verification ##{id_document.id}")
  end

  it "allows the user to verify an identity document" do
    submit_verification_form(document_type: "DNI", document_number: "XXXXXXXXY")

    expect(page).to have_content("User successfully verified")
    expect(page).to have_no_content("Verification #")
  end

  it "shows an error when information doesn't match" do
    submit_verification_form(document_type: "NIE", document_number: "XXXXXXXXY")

    expect(page).to have_content("Verification doesn't match")
    expect(page).to have_content("Introduce the data in the picture")
  end

  private

  def submit_verification_form(document_type:, document_number:)
    click_link "Verification ##{id_document.id}"
    select document_type, from: "Type of your document"
    fill_in "Document number (with letter)", with: document_number
    click_button "Verify"
  end
end
