# RackPassword
![](http://img.shields.io/gem/v/rack_password.svg?style=flat-square)
[![](http://img.shields.io/codeclimate/github/netguru/rack_password.svg?style=flat-square)](https://codeclimate.com/github/netguru/rack_password)
[![](http://img.shields.io/travis/netguru/rack_password.svg?style=flat-square)](ps://travis-ci.org/netguru/rack_password)

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

You can also provide custom validator:

```
config.middleware.use RackPassword::Block, auth_codes: ['janusz'], custom_rule: proc { |request| request.env['HTTP_USER_AGENT'].include?('facebook') }
```
## Common problems
- If you use server ip address instead of domain name to visit your webpage using chrome, rack_password will not accept any password, including the correct one. As a workaround, please use wildcard DNS service, such as [xip.io](http://xip.io/) 

## Contributing

1. Fork it ( https://github.com/netguru/rack_password/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
