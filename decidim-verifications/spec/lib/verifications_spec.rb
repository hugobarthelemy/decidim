# frozen_string_literal: true

require "spec_helper"

describe Decidim::Verifications, without_workflows: true do
  class CensusLetterDummyEngine < Rails::Engine; end
  class CensusLetterDummyAdminEngine < Rails::Engine; end

  before do
    described_class.register_workflow(:census_letter) do |workflow|
      workflow.engine = CensusLetterDummyEngine
      workflow.admin_engine = CensusLetterDummyAdminEngine
    end
  end

  describe ".register_workflow" do
    it "registers a verification workflow" do
      registered_workflow = described_class.find_workflow_manifest(:census_letter)

      expect(registered_workflow.engine).to eq(CensusLetterDummyEngine)
      expect(registered_workflow.admin_engine).to eq(CensusLetterDummyAdminEngine)
    end
  end

  describe ".verification_methods", without_handlers: true do
    before do
      Decidim.authorization_handlers = ["Decidim::DummyAuthorizationHandler"]
    end

    it ".authorization_workflows returns an array of workflow manifests" do
      workflows = described_class.workflows
      registered_workflow = described_class.find_workflow_manifest(:census_letter)

      expect(workflows).to eq([registered_workflow].to_set)
    end

    it ".verification_handlers returns an array of form classes" do
      auth_methods = Decidim.authorization_methods

      expect(auth_methods.map(&:name)).to eq(%w(Decidim::DummyAuthorizationHandler census_letter))
      expect(auth_methods.map(&:type)).to eq(%w(direct multistep))
    end
  end
end
