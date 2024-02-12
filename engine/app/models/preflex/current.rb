module Preflex
  class Current < ActiveSupport::CurrentAttributes
    attribute :controller_instance
    attribute :preference_cache
  end
end