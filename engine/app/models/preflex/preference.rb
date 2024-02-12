module Preflex
  class Preference < ApplicationRecord
    self.store_attribute_unset_values_fallback_to_default = true

    store :data, coder: JSON

    def get(name)
      name = name.to_sym
      self.class.ensure_preference_exists(name)

      send(name)
    end

    def set(name, value)
      name = name.to_sym
      self.class.ensure_preference_exists(name)

      send("#{name}=", value)
      send("#{name}_updated_at_epoch=", (Time.current.to_f * 1000).round)
      save!
    end

    def data_for_js
      data.to_json
    end

    def self.preference(name, type, default: nil, private: false)
      name = name.to_sym

      @preferences ||= Set.new
      @preferences.add(name)

      store_attribute(:data, name, type, default: default)
      store_attribute(:data, "#{name}_updated_at_epoch".to_sym, :integer, default: 0)
    end

    def self.current_owner(controller_instance)
      raise '
        Please define a class method called owner that returns the owner of this preference.
        You can use `controller_instance` to refer to things like current_user/etc.
        You can return either:
          an ActiveRecord object persisted in the DB
          or any object that responds to `id` - returning a unique id
          or a string that uniquely identifies the owner
        Example:
          def self.current_owner(controller_instance)
            controller_instance.current_user
          end
      '
    end

    def self.for(owner)
      owner = "#{owner.class.name}-#{owner.id}" if owner.respond_to?(:id)
      PreferenceCache.for(self, owner.to_s)
    end

    def self.current
      self.for(current_owner(Preflex::Current.controller_instance))
    end

    def self.get(name)
      current.get(name)
    end

    def self.set(name, value)
      current.set(name, value)
    end

    def self.ensure_preference_exists(name)
      raise "Preference #{name} was not defined. Make sure you define it (e.g. `preference :#{name}, :integer, default: 10`)" unless @preferences&.include?(name)
    end
  end
end
