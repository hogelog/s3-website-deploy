# S3WebsiteDeploy

s3-website-deploy is deploy tool for AWS S3 Website.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3-website-deploy'
```

## Usage

```console
$ bundle exec s3-website-deploy --bucket some-bucket --source build/ --region ap-northeast-1
I, [2018-05-22T00:18:01.580281 #37788]  INFO -- : Start deploying build/ -> s3://some-bucket/
I, [2018-05-22T00:18:02.841962 #37788]  INFO -- : Creating: favicon.ico
I, [2018-05-22T00:18:02.842058 #37788]  INFO -- : Creating: index.html
I, [2018-05-22T00:18:02.842105 #37788]  INFO -- : Finish deploying build/ -> s3://some-bucket/
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hogelog/s3-website-deploy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
