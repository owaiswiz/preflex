say "🗄️ Running migration to create a table to store preferences..."
rails_command("preflex:install:migrations")
rails_command("db:migrate")

say "🛠️ Setting up routes and a dummy initializer file"
route "mount Preflex::Engine => '/preflex'"
initializer 'preflex.rb', <<~RUBY
  # If you have a custom base controller, uncomment the below line and set it here.
  #Preflex.base_controller_class = '::ApplicationController'

  # If you want to make it so that the controller that handles requests to update preferences(from the client-side) inherits from a different base controller, uncomment the below line and set it here.
  #Preflex.base_controller_class_for_update = '::ApplicationController'
RUBY

create_example_preference = !no?("✨ Do you want to set up an example preference class? (Y/n)")

file_name = nil
if create_example_preference
  name = ask("✨ What do you want to call this class? (E.g UserPreference, FeatureFlag, CustomerSettings, etc.)").presence || 'CustomerSettings'
  file_name = "app/models/#{name.underscore}.rb"
  file file_name, <<~RUBY
    class #{name} < Preflex::Preference
      preference :autoplay,        :boolean, default: true
      preference :volume,          :integer, default: 75
      preference :title,           :string,  default: 'Mr.'
      preference :favorite_colors, :json,    default: ["red", "blue"]

      def self.current_owner(controller_instance)
        # You'd want to modify this to return the correct owner (whatever that is for you - can be an account/user/session/customer/etc - whatever you call it)
        controller_instance.current_user
      end
    end
  RUBY
end

say ""
say ""
say ""
say "✅ ✅ ✅     All done    ✅ ✅ ✅"
say ""
say "You might want to take a look at #{file_name} and update it's `current_owner` method definition." if create_example_preference
say "" if create_example_preference
say "You can also change the base controller that preflex uses if warranted. Take a look at config/initializers/preflex.rb"
say ""
say "If you'd like to easily read and write preferences from the client side, just add `Preflex::PreferencesHelper.script_tag(*AllThePreferenceClassesYouHave)` (e.g `Preflex::PreferencesHelper.script_tag(UserPreference, CustomerSettings)`) to the head tag in your layout file (e.g app/views/layouts/application.html.erb) and read the docs at https://github.com/owaiswiz/preflex"

def run_bundle; end;