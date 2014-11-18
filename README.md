# RackPassword

Small rack middleware to block your site from unwanted vistors. A little bit more convenient than basic auth - browser will ask you once for the password and then set a cookie to remember you - unlike the http basic auth it wont prompt you all the time.

## Installation

Add this line to your application's Gemfile:

    gem 'rack_password'

## Usage

Let's assume you want to password protect your staging environemnt. Add something like this to `config/environments/staging.rb `


```
config.middleware.use RackPassword::Block, auth_codes: ['janusz']
```

From now on, your staging app should prompt for `janusz` password before you access it.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack_password/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
