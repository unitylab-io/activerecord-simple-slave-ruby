# Activerecord::SimpleSlave

Provide a simple way to query a slave server (tested only with mysql2 adapter).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-simple-slave'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-simple-slave

## Usage

Extend your model with ActiveRecord::SimpleSlave module, then use :
```ruby
class Model < ActiveRecord::Base
  extend ActiveRecord::SimpleSlave
end

Model.with_slave do
  Model.first # this will hit your slave server
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord-simple-slave. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::Simple::Slave project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/activerecord-simple-slave/blob/master/CODE_OF_CONDUCT.md).