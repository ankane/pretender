# Pretender

As an admin, there are times you want to see exactly what another user sees.  Meet Pretender.

- Easily to switch between users
- Minimal code changes
- Plays nicely with auditing tools

:boom: [Rock on](http://www.youtube.com/watch?v=SBjQ9tuuTJQ)

Pretender is flexible and lightweight - less than 40 lines of code :-)

Works with any authentication system - [Devise](https://github.com/plataformatec/devise), [Authlogic](https://github.com/binarylogic/authlogic), and [Sorcery](https://github.com/NoamB/sorcery) to name a few.

:tangerine: Battle-tested at [Instacart](https://www.instacart.com/opensource)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'pretender'
```

And add this to your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  impersonates :user
end
```

## How It Works

Sign in as another user with:

```
impersonate_user(user)
```

The `current_user` method now returns the impersonated user.

You can access the true user with:

```
true_user
```

And stop impersonating with:

```ruby
stop_impersonating_user
```

### Sample Implementation

```ruby
class Admin::UsersController < ApplicationController
  before_filter :require_admin!

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end
end
```

Show when someone is signed in as another user in your application layout.

```erb
<% if current_user != true_user %>
  You (<%= true_user.name %>) are signed in as <%= current_user.name %>
  <%= link_to "Back to admin", stop_impersonating_path %>
<% end %>
```

## Audits

If you keep audit logs with a library like [Audited](https://github.com/collectiveidea/audited), make sure it uses the **true user**.

```ruby
Audited.current_user_method = :true_user
```

## Configuration

Pretender is super flexible.  You can change the names of methods and even impersonate multiple roles at the same time.  Here’s the default configuration.

```ruby
impersonates :user,
             method: :current_user,
             with: -> (id) { User.find_by(id: id) }
```

Mold it to fit your application.

```ruby
impersonates :account,
             method: :authenticated_account,
             with: -> (id) { EnterpriseAccount.find_by(id: id) }
```

This creates three methods:

```ruby
true_account
impersonate_account
stop_impersonating_account
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/pretender/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/pretender/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
