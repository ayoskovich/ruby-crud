# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Start

**Ruby Version:** 3.4.10
**Rails Version:** 8.1.3
**Database:** SQLite (development/test), configurable for production

### Essential Commands

```bash
# Development server
bin/dev

# Run all tests
bin/rails test

# Run system tests (integration tests with Capybara/Selenium)
bin/rails test:system

# Run a single test file
bin/rails test test/models/product_test.rb

# Run a specific test by line number
bin/rails test test/models/product_test.rb:6

# Lint code (RuboCop with Omakase style)
bin/rubocop
bin/rubocop -a  # Auto-fix issues

# Security checks
bin/brakeman          # Static analysis for Rails vulnerabilities
bin/bundler-audit     # Check gems for known vulnerabilities
bin/importmap audit   # Check JavaScript dependencies

# Full CI pipeline (runs locally)
bin/ci

# Rails console (useful for quick testing/exploration)
bin/rails console

# Database setup
bin/setup              # Initial setup
bin/rails db:migrate   # Run migrations
bin/rails db:seed      # Populate with seed data
```

## Architecture Overview

### Core Models

**Product** (`app/models/product.rb`)
- Main domain model representing store products
- Includes `Product::Notifications` concern for subscriber notifications
- Has file attachment (featured_image) via Active Storage
- Has rich text description via Action Text
- Validations: name presence, inventory_count >= 0

**Product::Notifications** (Concern in `app/models/product/notifications.rb`)
- Uses `after_update_commit` hook to send emails when product returns to stock
- Tracks when inventory changes from zero to positive
- Sends emails asynchronously via `ProductMailer.with(...).in_stock.deliver_later`
- Uses `solid_queue` for background job processing

**User** (`app/models/user.rb`)
- Authentication model with `has_secure_password` (bcrypt)
- Session management: `has_many :sessions, dependent: :destroy`
- Email normalization (strip + downcase)

**Session** (`app/models/session.rb`)
- Tracks authenticated user sessions
- Stores user_agent and ip_address for security

**Subscriber** (`app/models/subscriber.rb`)
- Association: `belongs_to :product`
- Generates secure tokens for unsubscribe links via `generates_token_for :unsubscribe`
- Users can subscribe to product re-stock notifications

### Controllers

All controllers inherit from `ApplicationController` which includes the `Authentication` concern.

**ProductsController** (`app/controllers/products_controller.rb`)
- Standard CRUD: index, show, new, create, edit, update, destroy
- Authentication: Public index/show, authenticated for create/update/destroy
- Uses `before_action :set_product` for show/edit/update/destroy
- Parameter filtering via `params.expect`: :name, :description, :featured_image, :inventory_count

**SubscribersController** (`app/controllers/subscribers_controller.rb`)
- Only action: create (nested under products)
- Route: POST /products/:product_id/subscribers
- Allows unauthenticated users to subscribe to product notifications

**UnsubscribesController** (`app/controllers/unsubscribes_controller.rb`)
- Singular resource (not nested)
- Handles unsubscribe token-based links

**SessionsController, PasswordsController** (`app/controllers/sessions_controller.rb`, `app/controllers/passwords_controller.rb`)
- Authentication flows
- Password reset functionality

### Authentication Pattern

The `Authentication` concern (`app/controllers/concerns/authentication.rb`) provides:
- `require_authentication` before_action (runs by default on all controllers)
- `allow_unauthenticated_access(only: [...])` class method to skip auth for specific actions
- Session management via signed cookies
- `Current.session` context isolation
- Session resumption and creation helpers

### Routing

Root: `products#index`
```
resources :products do
  resources :subscribers, only: [:create]
end
resource :unsubscribe, only: [:show]
resource :session
resources :passwords, param: :token
```

## Testing

Uses Rails 7+ built-in testing: `ActiveSupport::TestCase` with Capybara/Selenium for system tests.

**Test Structure:**
- `test/models/` - Model tests
- `test/controllers/` - Controller tests
- `test/integration/` - Integration tests
- `test/system/` - System/E2E tests

**Running Tests:**
- All: `bin/rails test`
- Models only: `bin/rails test:models`
- System tests: `bin/rails test:system`
- Single file: `bin/rails test test/models/product_test.rb`
- With pattern: `bin/rails test test/models/product_test.rb --name=test_name`

**Test Database:** Separate SQLite DB created automatically when running tests

## Dependencies & Key Gems

**Framework & ORM:**
- Rails 8.1.3
- sqlite3 (development/test)
- propshaft (asset pipeline)

**Frontend:**
- Hotwire: turbo-rails, stimulus-rails
- ImportMap for JavaScript bundling (no npm)

**Authentication & Security:**
- bcrypt (password hashing)
- Rails built-in: has_secure_password, generate_token_for

**Storage & Jobs:**
- solid_cache (database-backed caching)
- solid_queue (background job queue)
- solid_cable (WebSocket support)
- Action Storage (file uploads)
- Action Text (rich text editing)

**Development:**
- brakeman (security static analysis)
- bundler-audit (gem vulnerability scanning)
- rubocop-rails-omakase (Rails style guide enforcement)

**Testing:**
- capybara (web testing)
- selenium-webdriver (browser automation)

## Common Development Tasks

### Adding a New Feature

1. **Model Changes:** Add model, migrations, validations
2. **Controller:** Generate or modify controller with appropriate actions
3. **Routes:** Ensure routes.rb has the resource defined
4. **Tests:** Write tests for model logic, controller actions
5. **Views:** Create/update views as needed (uses ERB with Turbo)
6. **Run:** `bin/dev` to test locally, `bin/rails test` to verify

### Modifying the Product Model

The `Product::Notifications` concern handles stock notifications. If modifying inventory behavior:
- Concern's `back_in_stock?` method determines when to trigger notifications
- `notify_subscribers` sends the emails via ProductMailer
- Job execution: solid_queue processes `deliver_later` jobs asynchronously

### Running a Single Test During Development

```bash
# Run one test file
bin/rails test test/models/product_test.rb

# Run one test by name
bin/rails test test/models/product_test.rb --name=test_sends_email_notifications_when_back_in_stock
```

## File Organization

```
app/
  controllers/
    concerns/authentication.rb    # Auth middleware
    products_controller.rb        # CRUD for products
    subscribers_controller.rb     # Email subscription
    sessions_controller.rb        # Login/logout
  models/
    product.rb                    # Main model
    product/
      notifications.rb            # Concern: stock notifications
    subscriber.rb                 # Email subscribers
    user.rb                        # Authentication users
    session.rb                     # User sessions
config/
  routes.rb                       # Routing
  database.yml                    # DB configuration
  ci.rb                           # CI pipeline steps
test/
  models/                         # Unit tests
  system/                         # E2E tests
```

## Deployment

Uses Kamal for containerized deployment. Configuration in `.kamal/` directory. Docker support included via `Dockerfile`.

## Notes

- Email notifications use `deliver_later` (async). In dev, this may deliver immediately depending on config.
- Rich text descriptions use Action Text (stores in actiontext_rich_texts table)
- File uploads store in `storage/` directory (development only; use S3/other in production)
- PWA files in `app/views/pwa/` (manifest.json, service-worker.js) are currently not fully enabled
- Credentials stored in `config/credentials.yml.enc` (edit with `bin/rails credentials:edit`)
