require 'store_attribute'

module Preflex
  class Engine < ::Rails::Engine
    isolate_namespace Preflex

    initializer 'preflex.set_current_context' do |app|
      app.config.to_prepare do
        Preflex.base_controller_class.include(Preflex::SetCurrentContext)
        Preflex.base_controller_class_for_update.include(Preflex::SetCurrentContext) unless Preflex.base_controller_class_for_update < Preflex.base_controller_class
      end
    end
  end
end
