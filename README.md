
### RSpec Testing

The API uses RSpec for testing. Type `rspec` at the command line in the project
root to run the tests.

Project layout facilitates sharing the application configuration between
production, development and also test environments. Both the Rack configuration
and the RSpec helper require the configuration environment at
`config/environment`. This, in turn, requires `config/application` which sets
up module auto-loading using Active Support.

