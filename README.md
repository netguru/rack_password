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

## Options

You can also provide additional authentication rules in the options hash:

* `ip_whitelist` specifies allowed visitors IP addresses
* `path_whitelist` specifies allowed request path, it also works with regexp
* `custom_rule` provides custom validator

```
config.middleware.use RackPassword::Block,
    auth_codes: ['janusz'],
    ip_whitelist: ['82.43.112.65', '65.33.23.120'],
    path_whitelist: /\A\/(users|invitations)/,
    custom_rule: proc { |request| request.env['HTTP_USER_AGENT'].include?('facebook') }
```

The access is granted if at least one authentication rule is fulfilled (that includes `auth_codes` rule).

You can also provide `cookie_domain` option to override cookie domain. This way you can have one cookie shared across all subdomains.

```
config.middleware.use RackPassword::Block, auth_codes: ['janusz'], cookie_domain: '.somedomain.com'
```

The above code will make the authorization cookie shared across all `somedomain.com` subdomains, e.g. `a.somedomain.com` and `b.somedomain.com`. 

## Common problems
- If you use server ip address instead of domain name to visit your webpage using chrome, rack_password will not accept any password, including the correct one. As a workaround, please use wildcard DNS service, such as [xip.io](http://xip.io/) or set `cookie_domain` option to match server IP address.

## Contributing

1. Fork it ( https://github.com/netguru/rack_password/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
