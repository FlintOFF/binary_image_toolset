# BinaryImageToolset
[![Maintainability](https://api.codeclimate.com/v1/badges/47c89e40d6a9d319ac84/maintainability)](https://codeclimate.com/github/FlintOFF/binary_image_toolset/maintainability)

Welcome friend. This toolset gives you simple commands for work with binary images. The main features is:
- **find** frame position on frame
- **crop** frame
- **filter** frame using minor filter
- **fill** part of frame
- **erase** part of frame
- **create** frame

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binary_image_toolset'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binary_image_toolset

## Usage

```ruby
base_array = [%w(* * *), %w(* - -), %w(- * -), %w(- - *), %w(- - -)]
find_array = [%w(* * *)]
base_frame = BinaryImageToolset::Frame.new(base_array)
find_frame = BinaryImageToolset::Frame.new(find_array)
base_frame.find(find_frame, :standard)    
```
this part of code will return next responce
```ruby
[
  { position: [0, 1, 0, 2], percent: 100, overlap_percent: 67 },
  { position: [0, 1, 0, 3], percent: 100, overlap_percent: 100 },
  { position: [0, 1, 1, 2], percent: 100, overlap_percent: 67 }
]
```

The parameter `position` have format `[x_start, x_length, y_start, y_length]`
 
You can set next configs:
* `min_match` - percent of the minimum match
* `min_overlap` - percentage to search by part of the frame

```ruby
base_frame.find(find_frame, :standard, { min_match: 100, min_overlap: 100 })
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/binary_image_toolset. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BinaryImageToolset project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/binary_image_toolset/blob/master/CODE_OF_CONDUCT.md).
