# frozen_string_literal: true

require "spec_helper"

module Decidim::Verifications::IdDocuments::Admin
  describe IdDocumentForm do
    let(:user) { create(:user) }

    let!(:id_document) do
      create(:id_document, document_type: "DNI", document_number: "XXXXXXXXY")
    end

    let(:document_type) { "DNI" }
    let(:document_number) { "XXXXXXXXY" }

    subject do
      described_class.new(
        document_type: document_type,
        document_number: document_number,
        id_document: id_document,
        user: user
      )
    end

    context "when the information matches exactly" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "when document type is invalid" do
      let(:document_type) { "driver's license" }

      it "is not valid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:document_type]).to include("is not included in the list")
      end
    end

    context "when the document format is invalid" do
      let(:document_number) { "XXXXXXXX-Y" }

      it "is not valid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:document_number])
          .to include("must be all uppercase and contain only letters and/or numbers")
      end
    end

    context "when the information does not match" do
      context "document number" do
        let(:document_number) { "WAKAWAKA" }

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors.messages[:document_number])
            .to include("does not match what the user introduced")
        end
      end

      context "document type" do
        let(:document_type) { "NIE" }

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors.messages[:document_type])
            .to include("does not match what the user introduced")
        end
      end
    end
  end
end
