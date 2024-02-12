module Preflex::SetCurrentContext
  extend ActiveSupport::Concern

  included do
    before_action :preflex_set_current_context
  end

  protected

    def preflex_set_current_context
      Preflex::Current.controller_instance = self
    end
end
