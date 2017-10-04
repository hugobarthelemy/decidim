# frozen_string_literal: true

require "spec_helper"

module Decidim::Verifications::IdDocuments::Admin
  describe VerifyIdDocument do
    let(:document_number) { "XXXXXXXXY" }

    let!(:id_document) do
      create(:id_document, document_type: "DNI", document_number: document_number)
    end

    let(:handler) do
      IdDocumentForm.new(
        document_type: "DNI",
        document_number: document_number,
        id_document: id_document,
        user: create(:user)
      )
    end

    let(:user) { handler.user }

    subject { described_class.new(handler) }

    context "when the form is not authorized" do
      before do
        expect(handler).to receive(:valid?).and_return(false)
      end

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      it "creates an authorization for the user" do
        expect { subject.call }.to change { user.authorizations.count }.by(1)
      end

      it "stores no metadata" do
        subject.call

        expect(user.authorizations.first.metadata).to be_empty
      end

      it "stores a hashed version of the unique id" do
        subject.call

        expect(user.authorizations.first.unique_id).to_not be_empty
        expect(user.authorizations.first.unique_id).to_not eq("XXXXXXXXY")
      end
    end

    describe "uniqueness" do
      let(:unique_id) { "foo" }

      context "when there's no other authorizations" do
        it "is valid if there's no authorization with the same id" do
          expect { subject.call }.to change { user.authorizations.count }.by(1)
        end
      end

      context "when there's other authorizations" do
        let!(:other_user) { create(:user, organization: user.organization) }

        before do
          create(:authorization,
                 user: other_user,
                 unique_id: handler.unique_id,
                 name: handler.handler_name)
        end

        it "is invalid if there's another authorization with the same id" do
          expect { subject.call }.to change { user.authorizations.count }.by(0)
        end
      end
    end

    describe "privacy" do
      it "deletes the uploaded document after a successful verification" do
        expect { subject.call }.to change {
          Decidim::Verifications::IdDocuments::IdDocument.count
        }.by(-1)
      end
    end
  end
end
