# Preflex
<a href="https://badge.fury.io/rb/preflex"><img src="https://badge.fury.io/rb/preflex.svg" alt="Gem Version" height="18"></a> <img alt="Gem Total Downloads" src="https://img.shields.io/gem/dt/preflex">


A simple but powerful Rails engine for storing user preferences, feature flags, etc. With support for reading/writing values client-side!

## Dependency
Requires Rails 6.1+. (i.e works on Rails 6.1, Rails 7, Rails 7.1, ...)

## Installation

Add `preflex` to your `Gemfile`.
```ruby
gem 'preflex'
```

Run bundle install
```shell
bundle install
```

Run the Preflex installer.
```shell
bundle exec rails preflex
```
This will generate a create a table to store preferences, generate a dummy initializer file, mount the engine at `/preflex` in your `routes.rb` as well as ask you if you want to create an example preference class.

## Usage

### Create a preference sub-class

If you used the installer above, it would've already done this for you, after prompting you. But for context, here's what a preference class looks like

```ruby
# app/models/user_preference.rb
class UserPreference < Preflex::Preference
  preference :playback_rate,  :integer, default: 1
  preference :volume,         :integer, default: 80
  preference :theatre_mode,   :boolean, default: false
  preference :favorite_colors :json,    default: ['red', 'blue']
end
```

### Reading & writing values from Ruby

```ruby
UserPreference.for(current_user).get(:playback_rate) # => 1
UserPreference.for(current_user).set(:volume, 100)
UserPreference.for(current_user).get(:volume)        # => 100
```

### Reading & writing values from Ruby (Simpler)

If you just specify a `current_owner` class method that returns the owner of the preference in context of a controller request like below:

```ruby
class UserPreference < Preflex::Preference
  ...
  ...

  # This is the owner of this preference
  # It can be any unique object.
  # Either a ActiveRecord object like instance of your User/Customer/Account model.
  # Or even just a unique number/string/etc.
  def self.current_owner(controller_instance)
    controller_instance.current_user
  end
end
```


You would then simply be able to read/write preferences any where in the app like (as long as you are in context of a controller request):
```ruby
UserPreference.get(:playback_rate)      # => 1
UserPreference.get(:theatre_mode)       # => false
UserPreference.set(:theatre_mode, true) # => true

# In case you'd like to be a bit more explicit,
# you can also do this:
UserPreference.current.get(:playback_rate) #=> 1
```

### Reading and writing values from JavaScript

Make sure you've specified `current_owner` as described above. And then add this to the head tag in your layout file (e.g app/views/layouts/application.html.erb)

```html
<!-- e.g in app/views/layout/application.html.erb -->
<html>
  <head>
    <%= Preflex::PreferencesHelper.script_tag(UserPreference) %>
    ...
  </head>
  ...
</html>
```

You'll then be able to read and write values from Javascript like so:
```js
console.log(UserPreference.get('playback_rate'))     // => 1
console.log(UserPreference.get('favorite_colors'))   // => ['red', 'blue']

UserPreference.set('favorite_colors', ['orange', 'white'])

console.log(UserPreference.get('favorite_colors'))   // => ['orange', 'white']
```
This will update things on the client instantly + also send a request to your server to persit the preference change in the database.

#### Listening to when a preference was updated
```js
document.addEventListener('preflex:preference-updated', (e) => { console.log("Event detail:", e.detail) })

UserPreference.set('favorite_colors', ['orange', 'white'])
// => Event detail: { klass: 'UserPreference', name: 'favorite_colors', value: ['orange', 'white'] }

```


## FAQs

### How are things stored?

When you first install the gem and run `bundle exec rails preflex`, we create a single table in your database called `preflex_preferences`. All preferences are stored there.

When you create a new preference class, it's just an STI child of the `Preflex::Preference` model that the engine defines. So you don't need to run any migrations to create new tables/etc. later.

If you read/write values client side, we also store a copy in local storage when you write things client side (so your preference values are always instantly updated client-side). But we also do a POST request to let the server know of the change.


### What data types can I use in my preferences?
I'd recommend limiting yourself to `:integer, :boolean, :string, :big_integer, :float, :json`.

Preflex uses [store_attribute](https://github.com/palkan/store_attribute) under the hood, so any thing that it supports should work, but if you also read/write values from the client side, things like date time might not be serialized properly.

### How are things updated from the client side?
Updating things from JavaScript will instantly update a copy of the data in local storage. And emit a `preflex:preference-updated` event. It will also do a POST request to your server to persist the change in the database.

Preflex defines a super-simple `Preflex::PreferencesController` with a single update action to handle that. It will:
1. Get the preference class from params,
2. Load it's current instance - e.g UserPreference.current
   (so you must define `current_owner` as described above in your preferences class if updating things client side)
3. Get the name and value in params and do the update.


### Can I define multiple classes for storing different types of preferences?
Yes, you can create as many preference classes as you want grouping different domains of preference settings.

For example, you might have a multi-tenant application that has multiple `Account` objects, and there are also `User` objects which can belong to multpile  accounts.

So as an example, you can do a preference class for account, to store account level preferences like feature flags. And another preference class for user, for things like their playback rate, dark mode preference.

```ruby
# app/models/feature_flags.rb
class FeatureFlags < Preflex::Preference
  preference :new_navigation,   :boolean, default: false
  preference :email_builder_v2, :boolean, default: true

  def self.current_owner(controller_instance)
    controller_instance.current_account
  end
end

# app/models/user_preference.rb
class UserPreference < Preflex::Preference
  preference :dark_mode,     :boolean, default: false
  preference :playback_rate, :integer, default: 1

  def self.current_owner(controller_instance)
    controller_instance.current_account
  end
end
```

## Questions/Issues

Feel free to open an issue if you've got a question/problem.