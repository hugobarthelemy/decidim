# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example, without_handlers: true) do |example|
    begin
      previous_handlers = Decidim.authorization_handlers

      Decidim.authorization_handlers = []

      example.run
    ensure
      Decidim.authorization_handlers = previous_handlers
    end
  end

  config.around(:example, without_workflows: true) do |example|
    begin
      previous_workflows = Decidim::Verifications.workflows.dup
      Decidim::Verifications.clear_workflows
      Rails.application.reload_routes!

      example.run
    ensure
      Decidim::Verifications.reset_workflows(*previous_workflows)
      Rails.application.reload_routes!
    end
  end
end
