require 'store_attribute'

module Preflex
  class Engine < ::Rails::Engine
    isolate_namespace Preflex

    initializer 'preflex.set_current_context' do |app|
      include_current_context = -> {
        Preflex.base_controller_class.include(Preflex::SetCurrentContext)
        Preflex.base_controller_class_for_update.include(Preflex::SetCurrentContext) unless Preflex.base_controller_class_for_update < Preflex.base_controller_class
      }
      app.config.after_initialize do
        include_current_context.call
        app.reloader.to_prepare do
          include_current_context.call
        end
      end
    end
  end
end
