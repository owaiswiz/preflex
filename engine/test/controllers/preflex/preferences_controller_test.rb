require "test_helper"

module Preflex
  class PreferencesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @preference = preflex_preferences(:one)
    end

    test "should get index" do
      get preferences_url
      assert_response :success
    end

    test "should get new" do
      get new_preference_url
      assert_response :success
    end

    test "should create preference" do
      assert_difference("Preference.count") do
        post preferences_url, params: { preference: { data: @preference.data, owner_id: @preference.owner_id, owner_type: @preference.owner_type, type: @preference.type } }
      end

      assert_redirected_to preference_url(Preference.last)
    end

    test "should show preference" do
      get preference_url(@preference)
      assert_response :success
    end

    test "should get edit" do
      get edit_preference_url(@preference)
      assert_response :success
    end

    test "should update preference" do
      patch preference_url(@preference), params: { preference: { data: @preference.data, owner_id: @preference.owner_id, owner_type: @preference.owner_type, type: @preference.type } }
      assert_redirected_to preference_url(@preference)
    end

    test "should destroy preference" do
      assert_difference("Preference.count", -1) do
        delete preference_url(@preference)
      end

      assert_redirected_to preferences_url
    end
  end
end
