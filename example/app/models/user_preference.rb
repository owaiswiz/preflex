class UserPreference < Preflex::Preference
  preference :playback_rate, :integer, default: 1
  def self.current_owner(controller_instance)
    controller_instance.current_user
  end
end