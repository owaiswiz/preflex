module Preflex
  class PreferencesController < ApplicationController
    before_action :set_preference, only: %i[ show edit update destroy ]

    # GET /preferences
    def index
      @preferences = Preference.all
    end

    # GET /preferences/1
    def show
    end

    # GET /preferences/new
    def new
      @preference = Preference.new
    end

    # GET /preferences/1/edit
    def edit
    end

    # POST /preferences
    def create
      @preference = Preference.new(preference_params)

      if @preference.save
        redirect_to @preference, notice: "Preference was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /preferences/1
    def update
      if @preference.update(preference_params)
        redirect_to @preference, notice: "Preference was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /preferences/1
    def destroy
      @preference.destroy!
      redirect_to preferences_url, notice: "Preference was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_preference
        @preference = Preference.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def preference_params
        params.require(:preference).permit(:type, :owner_type, :owner_id, :data)
      end
  end
end
