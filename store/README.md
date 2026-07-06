# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Notes

Start a console: `bin/rails console`

Create a new thing

```ruby
product = Product.new(name: "T-Shirt")
Product.create(name: "Another product")
Product.all
found_product = Product.find(2)
found_product.update(name: "Shoes")
found_product.destroy
```

To reload the console (changes aren't auto-refreshed like the web server)
`reload!`

Validators are put on the models:
```ruby
product = Product.new
product.save # returns false
product.errors.full_messages
```


To create controllers (--skip-routes will just not add the routes to `routes.rb`):

```
bin/rails generate controller Products index --skip-routes
```


To add authentication:

```
bin/rails generate authentication
bin/rails db:migrate
bin/rails console
User.create! email_address: "test@example.com", password: "test", password_confirmation: "test"
```


I tried to install action_text with `bundle install` but got this:

```
Bundler::PermissionError: There was an error while trying to write to `/usr/lib/ruby/gems/3.4.0/cache`. It is likely that you
need to grant write permissions for that path.
```

To fix, run this:

```
bundle config set --local path 'vendor/bundle'
```

Format a db query, use `.map`:

```ruby
Subscriber.includes(:product).map { |s| "#{s.email} - #{s.product.name}" }
```


Format code with `bin/rubocop -a`
Check for security issues with `bin/brakeman`
