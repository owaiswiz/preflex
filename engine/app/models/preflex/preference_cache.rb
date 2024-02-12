module Preflex
  class PreferenceCache
    def initialize
      @cache = {}
    end

    def for(klass, owner)
      @cache[klass] ||= {}
      @cache[klass][owner] ||= klass.find_or_initialize_by(owner: owner)
    end

    def self.for(klass, owner)
      self.current.for(klass, owner)
    end

    def self.current
      Preflex::Current.preference_cache ||= new
    end
  end
end