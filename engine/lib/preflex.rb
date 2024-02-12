require "preflex/version"
require "preflex/engine"

module Preflex
  mattr_accessor :base_controller_class
  mattr_accessor :base_controller_class_for_update

  def self.base_controller_class
    (@@base_controller_class || '::ApplicationController').constantize
  end

  def self.base_controller_class_for_update
    @@base_controller_class_for_update&.constantize || self.base_controller_class
  end
end
