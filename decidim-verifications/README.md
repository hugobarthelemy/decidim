# Decidim

Adds multi-step verification methods to decidim. With `decidim-verifications`
you can implement custom verification scenarios that require several frontend
and/or backend step via custom engines.

## Usage

Define your verification flow via custom engines and register them in an
initializer.

For example:

```ruby
Decidim::Verifications.register_workflow(:sms_verification) do |workflow|
  workflow.engine = Decidim::Verifications::SmsVerification::Engine
  workflow.admin_engine = Decidim::Verifications::SmsVerification::AdminEngine
end
```

You need to make sure that the last step of your scenario creates an
`Authorization` record for the user. You might want to inherit from
`AuthorizeUser` rectify command in your controller to achieve that.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-verifications'
```

And then execute:

```bash
$ bundle
```

## Contributing
See [Decidim](https://github.com/decidim/decidim).

## License
See [Decidim](https://github.com/decidim/decidim).
