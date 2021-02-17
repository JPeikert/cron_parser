# Cron Parser
Parse your cron expressions to easier to understand form.

## Clean OS setup
1. Consider using one of version managers for Ruby, like [RVM](https://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv)
2. Use [official guide](https://www.ruby-lang.org/en/documentation/installation/) to install ruby
3. Install bundler `gem install bundler`

## Setup & Testing
1. Run `bundle install` to setup dependencies.
2. Run `bundle exec rake spec` to run the tests.

## Usage
To parse and print a cron expression use:

```bash
rake cron_parser:print "{cron expression}"
```

i.e.
```bash
rake cron_parser:print "*/15 0 1,15 * 1-6,5 /u/bin/find"
```
