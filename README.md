# Hacker's Note

It's a Ruby script creates a gitbook compatible structure for penetration test and red team projects 
The main target of this script is to make building [gitbook](https://www.gitbook.com/editor) project for a new PT/RT engagement easily.

## Installation

    $ gem install hackernote

## Usage

TODO: Write usage instructions here


## Document Structure
The script create a tree of folders and files for each target 

- Project Name
  - Target1/
    - target1.md
    - scanning_and_enumeration.md
    - critical 
    - high.md
    - medium.md
    - low
    - informational.md
    - notes
  - TargetX/ 
    - target1.md
    - scanning_and_enumeration.md
    - critical 
    - high.md
    - medium.md
    - low
    - informational.md
    - notes
  - README.md
  - book.json


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hackernote.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
