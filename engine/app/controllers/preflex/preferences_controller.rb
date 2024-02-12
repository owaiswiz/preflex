module Preflex
  class PreferencesController < ApplicationController
    # POST /preferences
    #  Params:
    #     klass
    #     name
    #     value
    def update
      klass = params[:klass].constantize
      raise "Expected #{params[:klass]} to be a subclass of Preflex::Preference" unless klass < Preflex::Preference

      klass.set(params[:name], params[:value])
      head :ok
    end
  end
end
