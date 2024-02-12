require 'store_attribute'

module Preflex
  class Engine < ::Rails::Engine
    isolate_namespace Preflex

    config.to_prepare do
      Preflex.base_controller_class.include(Preflex::SetCurrentContext)
    end
  end
end
